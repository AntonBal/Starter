//
//  Network+Headers.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import Alamofire

extension Network.Header {
    static func accept(contentTypes: [String]) -> Network.Header {
        HTTPHeader.accept(contentTypes.joined(separator: ", "))
    }
    
    static var defaultAccept: Network.Header {
        accept(contentTypes: ["application/json"])
    }
}
