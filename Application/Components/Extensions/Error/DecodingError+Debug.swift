//
//  DecodingError+Debug.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

extension DecodingError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .dataCorrupted(let context):
            return "Data corrupted @ \(context.keyPath)"
        case .keyNotFound(let key, let context):
            return "Key '\(key.keyPath)' not found @ \(context.keyPath)"
        case .typeMismatch(let type, let context):
            return "Type mismatch '\(type)' @ \(context.keyPath)"
        case .valueNotFound(let type, let context):
            return "Value '\(type)' not found @ \(context.keyPath)"
        @unknown default:
            return String(describing: self)
        }
    }
}

private extension DecodingError.Context {
    var keyPath: String {
        return codingPath.map { $0.keyPath }.joined(separator: ".")
    }
}

private extension CodingKey {
    var keyPath: String {
        return intValue.flatMap(String.init) ?? stringValue
    }
}
