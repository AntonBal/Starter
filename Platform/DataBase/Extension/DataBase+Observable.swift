//
//  DataBase+Observable.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift
import class ReactiveSwift.Property

extension Database {
    func observe<T: DatabaseRepresentable>(_ value: T, context: T.Context) -> AsyncTask<T?>
        where
        T.ManagedObject: RealmSwift.Object
    {
        return perform { realm -> AsyncTask<T?> in
            let managedObject = try realm.fetch(value)
            return AsyncTask(value: try T(managedObject, context: context))
                .concat(managedObject.reactive
                    .observe()
                    .attemptMap { try $0.flatMap { try T($0, context: context) } })
        }
        .flatten(.latest)
        .observe(on: UIScheduler())
    }

    func observe<T: DatabaseRepresentable>(_ value: T) -> AsyncTask<T?>
        where
        T.ManagedObject: RealmSwift.Object,
        T.Context == Void
    {
        return observe(value, context: ())
    }

    func autoupdating<T: DatabaseRepresentable>(_ value: T, context: T.Context)
        -> Property<T?>
        where
        T.ManagedObject: RealmSwift.Object
    {
        let producer = observe(value, context: context)
            .ignoreError()
            .observe(on: UIScheduler())

        return Property(initial: value, then: producer)
    }

    func autoupdating<T: DatabaseRepresentable>(_ value: T)
        -> Property<T?>
        where
        T.ManagedObject: RealmSwift.Object,
        T.Context == Void
    {
        return autoupdating(value, context: ())
    }
}

