//
//  AuthorizationPlugin.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

protocol AccessTokenProvider: class {
    var accessToken: AccessToken { get }
//    var accessToken: Property<AccessToken?> { get }
    //func refreshToken(else error: Error) -> SignalProducer<Void, MoyaError>
}

final class AuthorizationPlugin: NetworkPlugin {
  
    private weak var accessTokenProvider: AccessTokenProvider?
    
    init(_ accessTokenProvider: AccessTokenProvider? = nil) {
        self.accessTokenProvider = accessTokenProvider
    }
    
    func prepare(_ request: URLRequest, target: RequestConvertible) -> URLRequest {
        with(request) { [accessTokenProvider] request in
            guard let provider = accessTokenProvider else { return }
            guard target.authorizationStrategy == .token else { return }
            request.headers.add(.authorization(bearerToken: provider.accessToken.tokenString))
        }
    }
    
    func should(retry target: RequestConvertible,
                dueTo error: Error,
                completion: @escaping (Network.RetryResult) -> Void) {
       
        if let provider = accessTokenProvider, let responseError = error as? APIError, responseError.responseCode == 401 {
//            accessTokenProvider.refreshToken(else: error)
//                .startWithResult { result in
//                    switch result {
//                    case .success:
//                        completion(true, .seconds(0))
//                    case .failure:
//                        completion(false, .seconds(0))
//                    }
//            }
        }
    }
}
