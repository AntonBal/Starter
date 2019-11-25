//
//  ServiceContext.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation

final class ServiceContext {
    
    let environment: PlatformEnvironment
    let network: Network
    let database: Database

    init(environment: PlatformEnvironment,
         network: Network,
         database: Database) {
        self.environment = environment
        self.network = network
        self.database = database
    }
}

