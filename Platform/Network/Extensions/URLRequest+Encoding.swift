//
//  URLRequest+Encoding.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import Alamofire

extension URLRequest {
    func encoded(_ parameters: Alamofire.Parameters,
                 encoding: Alamofire.ParameterEncoding) throws -> URLRequest {
        try encoding.encode(self, with: parameters)
    }

    func encoded(for target: RequestConvertible) throws -> URLRequest {
        switch target.task {
        case .requestPlain,
             .uploadFile,
             .uploadMultipart,
             .downloadDestination:
            return self
        case .requestData(let body):
            return with(self) { $0.httpBody = body }
        case .requestParameters(let parameters, let encoding):
            return try encoded(parameters, encoding: encoding)
        case .requestCompositeData(let body, let urlParameters):
            return try with(self) { $0.httpBody = body }
                .encoded(urlParameters, encoding: URLEncoding.default)
        case .requestCompositeParameters(let bodyParameters,
                                         let bodyEncoding,
                                         let urlParameters):
            return try encoded(bodyParameters, encoding: bodyEncoding)
                .encoded(urlParameters, encoding: URLEncoding.default)
        case .uploadCompositeMultipart(let urlParameters, _):
            return try encoded(urlParameters, encoding: URLEncoding.default)
        case .downloadParameters(let parameters, let encoding, _):
            return try encoded(parameters, encoding: encoding)
        }
    }
}
