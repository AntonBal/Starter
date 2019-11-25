//
//  Network.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import Alamofire

final class Network {
    
    //MARK: - Defines
    
    typealias ResponseResult = Result<Response, Error>
    typealias RetryResult = Alamofire.RetryResult
    typealias Request = Alamofire.Request
    typealias Completion = (ResponseResult) -> Void
    typealias DownloadDestination = DownloadRequest.Destination
    typealias Method = Alamofire.HTTPMethod
    typealias MultipartFormDataBuilder = (MultipartFormData) -> Void
    typealias Header = HTTPHeader
    typealias Headers = HTTPHeaders
    
    //MARK: - Properies
    
    private let session: Alamofire.Session
    private let baseURL: URL
    private let plugins: [NetworkPlugin]
    
    class var defaultHeaders: Headers {
        with(.default) { $0.add(.defaultAccept) }
    }
    
    init(baseURL: URL,
         plugins: [NetworkPlugin] = [],
         timeoutIntervalForRequest: TimeInterval = 30,
         commonHeaders: Headers = defaultHeaders) {
        self.baseURL = baseURL
        self.plugins = plugins
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.headers = commonHeaders
        session = Alamofire.Session(configuration: configuration, startRequestsImmediately: false)
    }
    
    func request(_ target: RequestConvertible,
                 qos: DispatchQoS.QoSClass = .default,
                 completion: @escaping Completion) -> Cancellable {
        performRequest(target,
                       queue: .global(qos: qos),
                       completion: completion)
    }
    
    // MARK: - Private
    
    private func performRequest(_ target: RequestConvertible,
                                queue: DispatchQueue,
                                completion: @escaping Completion) -> Cancellable {
        let token = CancellableToken()
        let commonCompletion: Completion = { [weak self] result in
            guard let self = self else { return }
            self.didReceive(result, target: target)
            let result = self.process(result, target: target)
            self.handleResult(result,
                              target: target,
                              queue: queue,
                              token: token,
                              completion: completion)
        }
        
        do {
            let urlRequest = try makeURLRequest(for: target)
            switch target.task {
            case .requestPlain,
                 .requestData,
                 .requestParameters,
                 .requestCompositeData,
                 .requestCompositeParameters:
                return performData(urlRequest,
                                   token: token,
                                   queue: queue,
                                   target: target,
                                   completion: commonCompletion)
            case .downloadDestination(let destination),
                 .downloadParameters(_, _, let destination):
                return performDownload(urlRequest,
                                       destination: destination,
                                       token: token,
                                       queue: queue,
                                       target: target,
                                       completion: commonCompletion)
            case .uploadFile(let fileURL):
                return performUpload(urlRequest,
                                     fileURL: fileURL,
                                     token: token,
                                     queue: queue,
                                     target: target,
                                     completion: commonCompletion)
            case .uploadMultipart(let builder),
                 .uploadCompositeMultipart(_, let builder):
                return performUpload(urlRequest,
                                     builder: builder,
                                     token: token,
                                     queue: queue,
                                     target: target,
                                     completion: commonCompletion)
            }
        } catch {
            queue.async {
                guard !token.isCancelled else { return }
                commonCompletion(.failure(error))
            }
            return token
        }
    }
    
    // MARK: - Data request
    
    private func performData(_ request: URLRequest,
                             token: CancellableToken,
                             queue: DispatchQueue,
                             target: RequestConvertible,
                             completion: @escaping Completion) -> Cancellable {
        let task = session
            .request(request)
            .responseData(queue: queue) { response in
                guard !token.isCancelled else { return }
                completion(Result { try Response(response) })
        }
        token.didCancel {
            task.cancel()
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    // MARK: - Download request
    
    private func performDownload(_ request: URLRequest,
                                 destination: DownloadDestination?,
                                 token: CancellableToken,
                                 queue: DispatchQueue,
                                 target: RequestConvertible,
                                 completion: @escaping Completion) -> Cancellable {
        let task = session
            .download(request, to: destination)
            .responseData(queue: queue) { response in
                guard !token.isCancelled else { return }
                completion(Result { try Response(response) })
        }
        token.didCancel {
            task.cancel()
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    // MARK: - Upload request
    
    private func performUpload(_ request: URLRequest,
                               fileURL: URL,
                               token: CancellableToken,
                               queue: DispatchQueue,
                               target: RequestConvertible,
                               completion: @escaping Completion) -> Cancellable {
        let task = session
            .upload(fileURL, with: request)
            .responseData(queue: queue) { response in
                guard !token.isCancelled else { return }
                completion(Result { try Response(response) })
        }
        token.didCancel {
            task.cancel()
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    private func performUpload(_ request: URLRequest,
                               builder: MultipartFormDataBuilder,
                               token: CancellableToken,
                               queue: DispatchQueue,
                               target: RequestConvertible,
                               completion: @escaping Completion) -> Cancellable {
        let formData = MultipartFormData()
        builder(formData)
        
        let task = session
            .upload(multipartFormData: formData, with: request)
            .responseData(queue: queue) { response in
                guard !token.isCancelled else { return }
                completion(Result { try Response(response) })
        }
        token.didCancel {
            task.cancel()
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    // MARK: - URLRequest builder
    
    private func makeBaseURL(for target: RequestConvertible) throws -> URL {
        return target.baseURL ?? baseURL
    }
    
    private func makeURLRequest(for target: RequestConvertible) throws -> URLRequest {
        let url = try makeBaseURL(for: target).appendingPathComponent(target.path)
        var request = try URLRequest(url: url).encoded(for: target)
        request.httpMethod = target.method.rawValue
        target.headers?.dictionary.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return try prepare(request, target: target)
    }
    
    // MARK: - Handle result
    
    private func handleResult(_ result: ResponseResult,
                              target: RequestConvertible,
                              queue: DispatchQueue,
                              token: CancellableToken,
                              completion: @escaping Completion) {
        guard case .failure(let error) = result else {
            completion(result)
            return
        }
        should(retry: target, dueTo: error, plugins: plugins) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .doNotRetry:
                completion(result)
            case .doNotRetryWithError(let newError):
                completion(.failure(newError))
            case .retry:
                let innerToken = self.performRequest(target,
                                                     queue: queue,
                                                     completion: completion)
                token.didCancel {
                    innerToken.cancel()
                }
            case .retryWithDelay(let interval):
                queue.asyncAfter(deadline: .now() + interval) { [weak self] in
                    guard !token.isCancelled, let self = self else { return }
                    let innerToken = self.performRequest(target,
                                                         queue: queue,
                                                         completion: completion)
                    token.didCancel {
                        innerToken.cancel()
                    }
                }
            }
        }
    }
}

// MARK: - Handle NetworkPlugin methods

extension Network {
    private func prepare(_ request: URLRequest,
                         target: RequestConvertible) throws -> URLRequest {
        try plugins.reduce(request) { try $1.prepare($0, target: target) }
    }
    
    private func willSend(_ request: Network.Request, target: RequestConvertible) {
        plugins.forEach { $0.willSend(request, target: target) }
    }
    
    private func didReceive(_ result: Network.ResponseResult,
                            target: RequestConvertible) {
        plugins.forEach { $0.didReceive(result, target: target) }
    }
    
    private func process(_ result: Network.ResponseResult,
                         target: RequestConvertible) -> Network.ResponseResult {
        plugins.reduce(result) { $1.process($0, target: target) }
    }
}

// MARK: - Handle RequestRetrier methods

extension Network {
    private func should(retry target: RequestConvertible,
                        dueTo error: Error,
                        plugins: [NetworkPlugin],
                        completion: @escaping (RetryResult) -> Void) {
        guard target.retryEnabled, let plugin = plugins.first else {
            completion(.doNotRetry)
            return
        }
        plugin.should(retry: target, dueTo: error) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .doNotRetry:
                self.should(retry: target,
                            dueTo: error,
                            plugins: Array(plugins.dropFirst()),
                            completion: completion)
            default:
                completion(result)
            }
        }
    }
}
