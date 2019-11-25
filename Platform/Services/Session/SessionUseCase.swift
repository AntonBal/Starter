//  
//  SessionUseCase.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import ReactiveSwift

protocol SessionUseCase: AutoUseCaseProvider {
    func signIn(_ params: SignInParams) -> AsyncTask<User>
    func logout() -> AsyncTask<Void>
    
    var didLogin: Signal<User, Never> { get }
    var didLogout: Signal<Void, Never> { get }
    var authorizedUser: AsyncTask<User> { get }
}
