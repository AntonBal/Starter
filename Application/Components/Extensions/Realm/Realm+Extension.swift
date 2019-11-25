//
//  Realm+Extension.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import RealmSwift

extension Realm {
    func objectsForPrimaryKeys<T: Object>(type: T.Type,
                                          keys: [Any]) -> Results<T> {
        guard let primaryKey = T.primaryKey() else {
            return objects(type)
        }
        return objects(type).filter("\(primaryKey) IN %@", keys)
    }

    func fetchOrCreate<T: Object, Key>(_ type: T.Type,
                                       forPrimaryKey key: Key? = nil) -> T {
        guard let primaryKey = T.primaryKey(), let key = key else {
            return T()
        }
        return create(type, value: [primaryKey: key], update: .all)
    }
}

