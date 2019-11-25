//
//  Network+Response.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

extension Network {
    class Response {
        let data: Data
        let response: HTTPURLResponse
        let request: URLRequest?
        let metrics: URLSessionTaskMetrics?

        var statusCode: Int {
            response.statusCode
        }

        init(data: Data,
             response: HTTPURLResponse,
             request: URLRequest? = nil,
             metrics: URLSessionTaskMetrics? = nil) {
            self.data = data
            self.request = request
            self.response = response
            self.metrics = metrics
        }
    }
}

extension Network.Response {
    func decode<T: Decodable>(_ type: T.Type,
                              decoder: JSONDecoder = JSONDecoder()) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
