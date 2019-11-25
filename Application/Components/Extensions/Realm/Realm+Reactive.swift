//
//  Realm+Reactive.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import ReactiveSwift
import RealmSwift

extension Reactive where Base: RealmSwift.Object {
    func observe() -> AsyncTask<Base?> {
        return AsyncTask { [base] observer, lifetime in
            let token = base.observe { change in
                switch change {
                case .change:
                    observer.send(value: base)
                case .deleted:
                    observer.send(value: nil)
                    observer.sendCompleted()
                case .error(let error):
                    observer.send(error: .underlying(error))
                }
            }
            lifetime.observeEnded {
                token.invalidate()
            }
        }
    }
}
