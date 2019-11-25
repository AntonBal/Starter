//
//  DataBase+Persistable.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import RealmSwift

extension Database {
    func persist<T: Persistable>(_ value: T, context: T.Context) -> AsyncTask<T.ManagedObject>
        where
        T.ManagedObject: Object
    {
        return performWrite { realm in
            try realm.createOrUpdate(from: value, context: context)
        }
    }
    
    func persist<T: Persistable>(_ value: T) -> AsyncTask<T.ManagedObject>
        where
        T.ManagedObject: Object,
        T.Context == Void
    {
        return persist(value, context: ())
    }

    func persist<T: PersistableCollection>(_ values: T,
                                           context: T.Item.Context) -> AsyncTask<[T.Item.ManagedObject]>
        where
        T.Item.ManagedObject: Object
    {
        return performWrite { realm in
            try realm.createOrUpdate(from: values.items, context: context)
        }
    }
    
    func persist<T: PersistableCollection>(_ values: T) -> AsyncTask<[T.Item.ManagedObject]>
        where
        T.Item.ManagedObject: Object,
        T.Item.Context == Void
    {
        return performWrite { realm in
            try realm.createOrUpdate(from: values.items, context: ())
        }
    }
    
    func persist<T: Persistable>(_ value: T,
                                   then action: ((Realm, T.ManagedObject) throws -> Void)? = nil)
          -> AsyncTask<T.ManagedObject>
          where
          T.ManagedObject: Object,
          T.Context == Realm
      {
          return performWrite { realm in
              try with(realm.createOrUpdate(from: value, context: realm)) {
                  try action?(realm, $0)
              }
          }
      }
    
    func persist<T: PersistableCollection>(_ values: T,
                                           then action: ((Realm, [T.Item.ManagedObject]) throws -> Void)? = nil)
        -> AsyncTask<[T.Item.ManagedObject]>
        where
        T.Item.ManagedObject: Object,
        T.Item.Context == Realm
    {
        return performWrite { realm in
            try with(realm.createOrUpdate(from: values.items, context: realm)) {
                try action?(realm, $0)
            }
        }
    }
}
