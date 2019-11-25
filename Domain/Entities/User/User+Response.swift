//
//  User+Response.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

extension User {
    struct Response: Decodable, Identifiable {
        let id: User.ID
        let firstName: String
        let lastName: String
    }
}

//MARK: - Persistable

extension User.Response: Persistable {
    func update(_ object: RMUser, context: Void) throws {
        object.firstName = firstName
        object.lastName = lastName
    }
}
