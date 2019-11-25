//
//  DatabaseError.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

enum DatabaseError: LocalizedError {
    case notFound(type: Any, id: Any)
}

