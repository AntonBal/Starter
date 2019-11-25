//
//  DatabaseRepresentable.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

protocol DatabaseRepresentable: Identifiable {
    associatedtype ManagedObject
    associatedtype Context

    init(_ object: ManagedObject, context: Context) throws
}

extension DatabaseRepresentable where Context == Void {
    init(_ object: ManagedObject) throws {
        try self.init(object, context: ())
    }
}

