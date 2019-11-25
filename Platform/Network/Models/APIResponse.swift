//
//  APIResponse.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

struct APIPageResponse<Value, Pagination> {
    let data: Value
    let pagination: Pagination

    func map<T>(_ transform: (Value) throws -> T) rethrows -> APIPageResponse<T, Pagination> {
        let newData = try transform(data)
        return APIPageResponse<T, Pagination>(data: newData, pagination: pagination)
    }
}

extension APIPageResponse where Pagination == Void {
    init(data: Value) {
        self.init(data: data, pagination: ())
    }
}

extension APIPageResponse: Decodable where Value: Decodable, Pagination: Decodable {}

struct APIResponse<Value> {
    let data: Value

    func map<T>(_ transform: (Value) throws -> T) rethrows -> APIResponse<T> {
        let newData = try transform(data)
        return APIResponse<T>(data: newData)
    }
}

extension APIResponse: Decodable where Value: Decodable {}

struct LimitOffsetPageResponse<Value> {
    let data: Value
    let pagination: LimitOffset.Response
}

extension LimitOffsetPageResponse: Decodable where Value: Decodable {}
