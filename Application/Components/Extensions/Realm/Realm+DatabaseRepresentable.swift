//
//  DataBase+DatabaseRepresentable.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import RealmSwift

extension Realm {
    func fetch<T: DatabaseRepresentable>(_ value: T) throws
        -> T.ManagedObject
        where
        T.ManagedObject: RealmSwift.Object
    {
        if let object = object(ofType: T.ManagedObject.self,
                               forPrimaryKey: value.id) {
            return object
        } else {
            throw DatabaseError.notFound(type: T.ManagedObject.self,
                                         id: value.id)
        }
    }

    func fetch<T: DatabaseRepresentable>(type: T.Type, by id: T.ID) throws -> T.ManagedObject
        where
        T.ManagedObject: RealmSwift.Object
    {
        if let object = object(ofType: T.ManagedObject.self,
                               forPrimaryKey: id) {
            return object
        } else {
            throw DatabaseError.notFound(type: T.ManagedObject.self,
                                         id: id)
        }
    }
}
