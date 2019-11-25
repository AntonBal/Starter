//
//  DataBase+DatabaseRepresentable.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

extension Realm {
    func fetch<T: Identifiable>(_ value: T) throws
        -> T.Owner.ManagedObject
        where
        T.Owner: DatabaseRepresentable,
        T.Owner.ManagedObject: RealmSwift.Object
    {
        if let object = object(ofType: T.Owner.ManagedObject.self,
                               forPrimaryKey: value.id.value) {
            return object
        } else {
            throw DatabaseError.notFound(type: T.Owner.ManagedObject.self,
                                         id: value.id)
        }
    }

    func fetch<T: DatabaseRepresentable>(_ id: Token<T, T.Identifier>) throws
        -> T.Owner.ManagedObject
        where
        T.Owner: DatabaseRepresentable,
        T.Owner.ManagedObject: RealmSwift.Object
    {
        if let object = object(ofType: T.Owner.ManagedObject.self,
                               forPrimaryKey: id.value) {
            return object
        } else {
            throw DatabaseError.notFound(type: T.Owner.ManagedObject.self,
                                         id: id)
        }
    }
}
