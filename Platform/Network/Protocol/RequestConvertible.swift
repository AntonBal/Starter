//
//  RequestConvertible.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

enum AuthorizationStrategy {
    case token
}

protocol RequestConvertible {
    /// Base URL for request, takes precedence over `baseURL` in `Network` if specified.
    var baseURL: URL? { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Network.Method { get }

    /// The type of HTTP task to be performed.
    var task: Network.Task { get }

    /// The headers to be used in the request.
    var headers: Network.Headers? { get }

    /// Should request be considered for retry
    var retryEnabled: Bool { get }

    /// Specify authorization strategy for request.
    var authorizationStrategy: AuthorizationStrategy? { get }
}

extension RequestConvertible {
    var baseURL: URL? { return nil }

    var headers: Network.Headers? { return nil }

    var retryEnabled: Bool { return true }

    var authorizationStrategy: AuthorizationStrategy? { return .token }
}
