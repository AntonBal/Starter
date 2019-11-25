//
//  API+Session.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

import Alamofire

extension API {
    enum Session: RequestConvertible {
        case signIn(SignInParams)
        case logout

        var path: String {
            switch self {
            case .signIn:
                return "sessions"
            case .logout:
                return "sessions"
            }
        }
        
        var method: Network.Method {
            switch self {
            case .signIn:
                return .post
            case .logout:
                return .delete
            }
        }
        
        var task: Network.Task {
            switch self {
            case .signIn(let params):
                return .requestParameters(parameters: params.builder.make(),
                                          encoding: JSONEncoding.default)
            case .logout:
                return .requestPlain
            }
        }
        
        var authorizationStrategy: AuthorizationStrategy? {
            switch self {
            case .signIn:
                return nil
            default:
                return .token
            }
        }
    }
}
