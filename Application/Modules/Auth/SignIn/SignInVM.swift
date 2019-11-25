//  
//  SignInVM.swift
//  Template
//
//  Created by Anton Bal’ on 11/25/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import ReactiveSwift

final class SignInVM: ViewModelProtocol {

    typealias UseCases = HasSessionUseCase

    private let params = MutableProperty<SignInParams?>(nil)
    
    let email = MutableProperty<String>("")
    let password = MutableProperty<String>("")
    lazy var signInAction = Action(unwrapping: params, execute: useCases.session.signIn)
  
    init() {
        params <~ email
            .combineLatest(with: password)
            .map { email, password -> SignInParams? in
                guard !email.isEmpty, !password.isEmpty else { return nil }
                return SignInParams(user: email, password: password)
        }
    }
}
