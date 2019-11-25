//
//  BaseVC+reactive.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

//MARK: - Alert errors

extension Reactive where Base: BaseVC {
    var errors: BindingTarget<Error> {
        return bindingTarget(type: Error.self)
    }
    
    var appErrors: BindingTarget<AppError> {
        return bindingTarget(type: AppError.self)
    }
    
    func bindingTarget<E: Error>(type: E.Type, okHandler: ((E)-> Void)? = nil) -> BindingTarget<E> {
        return makeBindingTarget { base, error in
            let okButtonTitle = "Ok"
            let message = error.localizedDescription
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler:  { _ in
                okHandler?(error)
            })
            alert.addAction(okAction)
            base.present(alert, animated: true, completion: nil)
        }
    }
}

