//
//  Database.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift

final class Database {
    fileprivate let databaseThread = BackgroundWorker(name: "DatabaseThread")

    func perform<Output>(on queue: DispatchQueue? = nil,
                         _ action: @escaping (Realm) throws -> Output) -> AsyncTask<Output> {
        return AsyncTask { [queue, databaseThread] observer, lifetime in
            let action = {
                guard !lifetime.hasEnded else { return }
                do {
                    let realm = try Realm()
                    do {
                        observer.send(value: try action(realm))
                        observer.sendCompleted()
                    } catch {
                        if realm.isInWriteTransaction {
                            realm.cancelWrite()
                        }
                        observer.send(error: AppError(error))
                    }
                } catch {
                    observer.send(error: AppError(error))
                }
            }
            if let queue = queue {
                queue.async(execute: action)
            } else {
                databaseThread.perform(action: action)
            }
        }
    }

    func performWrite<Output>(on queue: DispatchQueue? = nil,
                              _ action: @escaping (Realm) throws -> Output) -> AsyncTask<Output> {
        return perform {
            let wasInWriteTransaction = $0.isInWriteTransaction
            if !wasInWriteTransaction {
                $0.beginWrite()
            }
            let output = try action($0)
            if !wasInWriteTransaction {
                try $0.commitWrite()
            }
            return output
        }
    }
    
    func syncPerform<Output>( _ action: @escaping (Realm) throws -> Output) throws -> Output {
        let realm = try Realm()
        return try action(realm)
    }

    func deleteAll() throws {
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
}
