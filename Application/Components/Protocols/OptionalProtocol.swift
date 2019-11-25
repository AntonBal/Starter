//
//  OptionalProtocol.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

/// An optional protocol for use in type constraints.
public protocol OptionalProtocol {
    /// The type contained in the otpional.
    associatedtype Wrapped

    init(reconstructing value: Wrapped?)

    /// Extracts an optional from the receiver.
    var optional: Wrapped? { get }
}

extension Optional: OptionalProtocol {
    public var optional: Wrapped? {
        return self
    }

    public init(reconstructing value: Wrapped?) {
        self = value
    }
}
