//  
//  SessionService.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import ReactiveSwift

final class SessionService: SessionUseCase {
    
    // MARK: - Private properties

    private let session: MutableProperty<Session?>
    private let context: ServiceContext

    // MARK: - Public properties

    let accessToken: Property<AccessToken?>

    init(context: ServiceContext) {
        self.context = context
        self.session = MutableProperty(Session.fetch())
        self.accessToken = session.map { $0?.accessToken }

        // Observe current user changes
        self.user = session
            .flatMap(.latest) { ($0?.user).flatMap(context.database.autoupdating) ?? Property(value: nil) }
    }

    // MARK: - SessionUseCase

    let user: Property<User?>
    
    func signIn(_ params: SignInParams) -> AsyncTask<User> {
        return context
            .network
            .reactive
            .request(API.Session.signIn(params))
            .decode(APIResponse<SignInResponse>.self)
            .map { $0.data }
            .flatMap(.latest) { [weak self] in self?.handleSignInResponse($0) ?? .never }
            .observe(on: UIScheduler())
    }
    
    func logout() -> AsyncTask<Void> {
        return authorizedUser
            .then(context.network.reactive.request(API.Session.logout))
            .map(value: ())
            .flatMapError { error -> AsyncTask<Void> in
                if case .api = error {
                    return AsyncTask(value: ())
                } else {
                    return AsyncTask(error: error)
                }
        }
        .flatMap(.latest) { [weak self] in self?.handleLogout() ?? .never }
    }
    
    // MARK: - Private
    
    private func handleSignInResponse(_ response: SignInResponse) -> AsyncTask<User> {
        context
            .database
            .persist(response.user)
            .attemptMap { [weak self] in
                let session = try Session(user: User($0), accessToken: response.session)
                try session.save()
                self?.session.value = session
                return session.user
        }
    }
    
    private func handleLogout() -> AsyncTask<Void> {
        return context.database
            .performWrite { $0.deleteAll() }
            .observe(on: UIScheduler())
            .attempt { [weak self] in
                if let session = self?.session.value {
                    try session.invalidate()
                    self?.session.value = nil
                }
        }
    }
}

extension SessionService {
    var didLogin: Signal<User, Never> {
        let producer = user.producer
            .combinePrevious()
            .filterMap { $0?.id != $1?.id ? $1 : nil }
        return Signal { $1 += producer.start($0) }
            .observe(on: UIScheduler())
    }
    
    var didLogout: Signal<Void, Never> {
        let producer = user.producer
            .combinePrevious()
            .filter { $0 != nil && $1 == nil }
            .map(value: ())
        return Signal { $1 += producer.start($0) }
            .observe(on: UIScheduler())
    }
    
    var authorizedUser: AsyncTask<User> {
        return user.producer
            .promoteError(AppError.self)
            .take(first: 1)
            .attemptMap {
                if let user = $0 {
                    return user
                } else {
                    throw AppError.sessionRequired
                }
        }
    }
}
