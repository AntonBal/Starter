//
//  Alamofire+Response.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import Alamofire

extension Network.Response {
    convenience init(_ dataResponse: AFDataResponse<Data>) throws {
        try self.init(dataResponse.result,
                      dataResponse.response,
                      dataResponse.request,
                      dataResponse.metrics)
    }

    convenience init(_ dataResponse: AFDownloadResponse<Data>) throws {
        try self.init(dataResponse.result,
                      dataResponse.response,
                      dataResponse.request,
                      dataResponse.metrics)
    }

    convenience init(_ result: Result<Data, AFError>,
                     _ response: HTTPURLResponse?,
                     _ request: URLRequest?,
                     _ metrics: URLSessionTaskMetrics?) throws {
        switch result {
        case .success(let data):
            guard let response = response else {
                throw NetworkError.missingResponse
            }
            self.init(data: data,
                      response: response,
                      request: request,
                      metrics: metrics)
        case .failure(let error):
            throw error
        }
    }
}
