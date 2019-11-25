//
//  AppError.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

enum Permission {
    case location(always: Bool)
    case notifications
    case gallery
    case contacts
}

enum AppError: Error {
    case dealocated(Any)
    case noData(Any)
    case underlying(Error)
    case api(APIError)
    case decoding(DecodingError)
    case sessionRequired
    case permissionDenied(Permission)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .underlying(let error):
            return error.localizedDescription
        case .api(let error):
            return error.localizedDescription
        case .decoding(let error):
            return error.debugDescription
        case .permissionDenied(let permission):
            return "Unhandled permission error \(permission)"
        case .sessionRequired:
            return "Session is required"
        case .dealocated(let name):
            return "\(String(describing: name)) is dealocated"
        case .noData(let name):
            return "No data of \(String(describing: name))"
        }
    }
}

extension AppError {
    init(_ error: Error) {
        switch error {
        case let apiError as APIError:
            self = .api(apiError)
        case let decodingError as DecodingError:
            self = .decoding(decodingError)
        default:
            self = .underlying(error)
        }
    }
}
