//
//  APIError.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

public struct APIError: Decodable, LocalizedError {
    
    enum ErrorCodingKeys: CodingKey {
        case error
    }
    
    enum APIErrorCodingKeys: CodingKey {
        case code
        case message
    }
    
    public let code: String
    public var responseCode: Int?
    public let message: String

    public var errorDescription: String? { message }
    
    public init(from decoder: Decoder) throws {
        let errorContainer = try decoder.container(keyedBy: ErrorCodingKeys.self)
        let container = try errorContainer.nestedContainer(keyedBy: APIErrorCodingKeys.self, forKey: .error)
        code = try container.decode(String.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
    }
}
