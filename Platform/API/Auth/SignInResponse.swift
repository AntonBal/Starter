//
//  SignInResponse.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

struct SignInResponse: Decodable {
    let user: User.Response
    let session: AccessToken
}
