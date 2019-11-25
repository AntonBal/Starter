//
//  Platform.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import ReactiveSwift
import Bagel

final class Platform: UseCasesProvider {
    let session: SessionUseCase
    
    init(environment: PlatformEnvironment) {
        Platform.setupServices(configuration: environment)
        
        let context = ServiceContext(environment: environment,
                                     network: Network(baseURL: environment.baseURL),
                                     database: Database())
        session = SessionService(context: context)
    }
    
    public func didFinishLaunching(with options: [UIApplication.LaunchOptionsKey: Any]?) {
        #if !STAGE && !PRODUCTION
        Bagel.start()
        #endif
    }
}

