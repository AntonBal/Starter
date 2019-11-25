//
//  Network+Reactive.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import ReactiveSwift

extension Network: ReactiveExtensionsProvider {}

extension Reactive where Base == Network {
    func request(_ request: RequestConvertible,
                 qos: DispatchQoS.QoSClass = .default)
        -> AsyncTask<Network.Response>
    {
        return AsyncTask { [base] observer, lifetime in
            let cancellable = base.request(request, qos: qos) { result in
                switch result {
                case .success(let response):
                    observer.send(value: response)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: AppError(error))
                }
            }
            lifetime.observeEnded {
                cancellable.cancel()
            }
        }
    }
}
