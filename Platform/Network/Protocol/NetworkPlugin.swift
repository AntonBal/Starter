//
//  NetworkPlugin.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

/**
 - Note: Similar to Moya framework
 */

protocol NetworkPlugin {
    
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, target: RequestConvertible) throws -> URLRequest
    
    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: Network.Request, target: RequestConvertible)
    
    /// Called after a response has been received
    func didReceive(_ result: Network.ResponseResult, target: RequestConvertible)
    
    /// Called to modify a result before completion, but before the Network has invoked its completion handler.
    func process(_ result: Network.ResponseResult, target: RequestConvertible) -> Network.ResponseResult
    
    /// Should retry case for a request
    func should(retry target: RequestConvertible, dueTo error: Error,
                   completion: @escaping (Network.RetryResult) -> Void)
}

extension NetworkPlugin {
    func prepare(_ request: URLRequest, target: RequestConvertible) -> URLRequest { request }

    func willSend(_ request: Network.Request, target: RequestConvertible) { }

    func didReceive(_ result: Network.ResponseResult, target: RequestConvertible) { }

    func process(_ result: Network.ResponseResult,
                 target: RequestConvertible) -> Network.ResponseResult { result }

    func should(retry target: RequestConvertible, dueTo error: Error,
                completion: @escaping (Network.RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
