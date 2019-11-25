//
//  RMUser.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
final class RMUser: Object {
    override static func primaryKey() -> String? { return #keyPath(id) }
    
    //MARK: - Properies
    
    @objc dynamic var id: User.ID = -1
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
}

//MARK: - DatabaseRepresentable

extension User: DatabaseRepresentable {
    init(_ object: RMUser, context: Void) throws {
        
        self.init(id: ID(object.id),
                  firstName: object.firstName,
                  lastName: object.lastName)
    }
}
