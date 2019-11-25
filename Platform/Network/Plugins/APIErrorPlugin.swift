//
//  APIErrorPlugin.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

final class APIErrorPlugin: NetworkPlugin {
    func process(_ result: Network.ResponseResult,
                 target: RequestConvertible) -> Network.ResponseResult {
        guard case .success(let response) = result,
            400 ..< 600 ~= response.statusCode else { return result }
        if let serverError = HTTPServerError(statusCode: response.statusCode) {
            return .failure(serverError)
        }
        do {
            var responseError = try response.decode(APIError.self)
            responseError.responseCode = response.statusCode
            return .failure(responseError)
        } catch {
            return .failure(error)
        }
    }
}
