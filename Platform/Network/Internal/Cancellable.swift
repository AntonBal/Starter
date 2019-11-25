//
//  Cancellable.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

protocol Cancellable {
    var isCancelled: Bool { get }
    func cancel()
}

final class CancellableToken: Cancellable {
    private let token: Bool = false
    private var didCancelClosure: (() -> Void)?

    var isCancelled: Bool {
        return token //.value
    }

    func cancel() {
//        token.value = true
        didCancelClosure?()
    }

    func didCancel(_ action: @escaping () -> Void) {
        didCancelClosure = action
    }
}

