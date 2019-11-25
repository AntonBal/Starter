//
//  SignInParams.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

struct SignInParams {
    let user: String
    let password: String
    
    var builder: Parameters {
        return Parameters {
            $0.user <- user
            $0.password <- password
        }
    }
}
