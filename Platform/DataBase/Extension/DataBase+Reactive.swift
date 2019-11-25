//
//  DataBase+Reactive.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import RealmSwift
import ReactiveSwift

extension SignalProducerConvertible
    where
    Value: Persistable,
    Value.ManagedObject: Object,
    Error == AppError
{
    func persist(to database: Database,
                 context: Value.Context) -> SignalProducer<Value.ManagedObject, Error> {
        return producer.flatMap(.concat) { database.persist($0, context: context) }
    }
}

extension SignalProducerConvertible
    where
    Value: Persistable,
    Value.ManagedObject: Object,
    Value.Context == Void,
    Error == AppError
{
    func persist(to database: Database) -> SignalProducer<Value.ManagedObject, Error> {
        return producer.flatMap(.concat) { database.persist($0, context: ()) }
    }
}

extension SignalProducerConvertible
    where
    Value: PersistableCollection,
    Value.Item.ManagedObject: Object,
    Error == AppError
{
    func persist(to database: Database,
                 context: Value.Item.Context) -> SignalProducer<[Value.Item.ManagedObject], Error> {
        return producer.flatMap(.concat) { database.persist($0, context: context) }
    }
}

extension SignalProducerConvertible
    where
    Value: PersistableCollection,
    Value.Item.ManagedObject: Object,
    Value.Item.Context == Void,
    Error == AppError
{
    func persist(to database: Database) -> SignalProducer<[Value.Item.ManagedObject], Error> {
        return producer.flatMap(.concat) { database.persist($0, context: ()) }
    }
}

extension SignalProducerConvertible
    where
    Value: Persistable,
    Value.ManagedObject: Object,
    Value.Context == Realm,
    Error == AppError
{
    func persist(to database: Database) -> SignalProducer<Value.ManagedObject, Error> {
        return producer.flatMap(.concat) { value in
            database.performWrite { try $0.createOrUpdate(from: value, context: $0) }
        }
    }
}

extension SignalProducerConvertible
    where
    Value: PersistableCollection,
    Value.Item.ManagedObject: Object,
    Value.Item.Context == Realm,
    Error == AppError
{
    func persist(to database: Database) -> SignalProducer<[Value.Item.ManagedObject], Error> {
        return producer.flatMap(.concat) { database.persist($0) }
    }
}
