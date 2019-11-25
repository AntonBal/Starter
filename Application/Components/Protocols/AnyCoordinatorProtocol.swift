//
//  AnyCoordinatorProtocol.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

protocol AnyCoordinatorProtocol: class {
    func start()
    func stop()
}

extension AnyCoordinatorProtocol {
    func start() { }
    func stop() { }
}
