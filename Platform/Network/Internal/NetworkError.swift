//
//  NetworkError.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case missingResponse
    case sessionRequired
    case parametersEncoding(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingResponse:
            return "Missing response from server"
        case .parametersEncoding:
            return "Failed to encode request parameters"
        case .sessionRequired:
        return "Auth session is required"
        }
    }
}
