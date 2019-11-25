//
//  LimitOffset.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

struct LimitOffset {
    static let defaultLimit = 10

    enum CodingKeys: String, CodingKey {
        case offset
        case limit
    }

    let offset: Int
    let limit: Int

    init(offset: Int = 0, limit: Int = defaultLimit) {
        self.offset = offset
        self.limit = limit
    }

    var parameters: [String: Any] {
        let dict: [String: Any] = [CodingKeys.offset.stringValue: offset,
                                   CodingKeys.limit.stringValue: limit]
        return dict
    }

    var isFirstPage: Bool {
        return offset == 0
    }
}

extension LimitOffset {
    struct Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case total = "totalCount"
            case nextOffset = "nextOffset"
            case offset = "nextPage"
        }

        let total: Int
        let nextOffset: Int
        let offset: Int

        var hasMore: Bool {
            return total > nextOffset
        }
    }

    init(_ response: Response, limit: Int) {
        self.init(offset: response.nextOffset, limit: limit)
    }
}
