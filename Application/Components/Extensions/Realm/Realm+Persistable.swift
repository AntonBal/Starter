//
//  Realm+Persistable.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import RealmSwift

extension Realm {
    @discardableResult
    func createOrUpdate<T: Persistable>(from object: T, context: T.Context) throws
        -> T.ManagedObject
        where
        T.ManagedObject: RealmSwift.Object
    {
        let managedObject = fetchOrCreate(T.ManagedObject.self,
                                          forPrimaryKey: object.primaryKey)
        try object.update(managedObject, context: context)
        return managedObject
    }

    @discardableResult
    func createOrUpdate<T: Persistable>(from objects: [T], context: T.Context) throws
        -> [T.ManagedObject]
        where
        T.ManagedObject: RealmSwift.Object
    {
        return try objects.map {
            let object = fetchOrCreate(T.ManagedObject.self,
                                       forPrimaryKey: $0.primaryKey)
            try $0.update(object, context: context)
            return object
        }
    }
}

