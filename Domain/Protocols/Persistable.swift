//
//  Persistable.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

protocol Persistable {
    associatedtype ManagedObject
    associatedtype Context
    var primaryKey: Any { get }
    func update(_ object: ManagedObject, context: Context) throws
}

extension Persistable
    where
    Self: Identifiable {
    var primaryKey: Any { return id }
}

extension Persistable where Context == Void {
    func update(_ object: ManagedObject) throws {
        try update(object, context: ())
    }
}

protocol PersistableCollection {
    associatedtype Item: Persistable
    var items: [Item] { get }
}

extension Array: PersistableCollection where Element: Persistable {
    typealias Item = Element
    var items: [Item] { return self }
}
