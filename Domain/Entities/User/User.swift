//
//  User.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

struct User: Identifiable {
    
    typealias ID = Int64
    
    let id: ID
    let firstName: String
    let lastName: String
}
