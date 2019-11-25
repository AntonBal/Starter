//
//  HTTPServerError.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

enum HTTPServerError: LocalizedError {
    case internalServerError
    case serviceUnavailable

    init?(statusCode: Int) {
        switch statusCode {
        case 500:
            self = .internalServerError
        case 501 ..< 600:
            self = .serviceUnavailable
        default:
            return nil
        }
    }

    var errorDescription: String? {
        switch self {
        case .internalServerError:
            return "Internal Server Error"
        case .serviceUnavailable:
            return "Service Unavailable"
        }
    }
}
