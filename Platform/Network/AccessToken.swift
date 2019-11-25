//
//  AccessToken.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

final class AccessToken: Codable {
    enum CodingKeys: String, CodingKey {
        case tokenString = "accessToken"
        case refreshTokenString = "refreshToken"
        case expirationDate = "expiresAt"
    }
    
    let tokenString: String
    let refreshTokenString: String?
    private(set) var expirationDate: Date
        
    init(tokenString: String) {
        self.tokenString = tokenString
        refreshTokenString = ""
        expirationDate = Date()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tokenString = try container.decode(String.self, forKey: .tokenString)
        refreshTokenString = try container.decodeIfPresent(String.self, forKey: .refreshTokenString)

        let dateString = try container.decode(String.self, forKey: .expirationDate)
        expirationDate = ISO8601DateFormatter().date(from: dateString) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tokenString, forKey: .tokenString)
        try container.encode(refreshTokenString, forKey: .refreshTokenString)
    }
}
