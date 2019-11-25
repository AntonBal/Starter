//
//  Session.swift
//  Template
//
//  Created by Anton Bal’ on 11/24/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import Foundation
import RealmSwift
import KeychainAccess

final class Session: Codable {
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken
    }

    var user: User
    let accessToken: AccessToken

    init(user: User, accessToken: AccessToken) {
        self.user = user
        self.accessToken = accessToken
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(User.ID.self, forKey: .user)
        let realm = try Realm()
        let managedUser = try realm.fetch(type: User.self, by: id)
        user = try User(managedUser)
        accessToken = try container.decode(AccessToken.self,
                                           forKey: .accessToken)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(user.id, forKey: .user)
        try container.encode(accessToken, forKey: .accessToken)
    }
}

extension Session {
    enum KeychainKey {
        static let session = "session"
    }

    static var keychain: Keychain {
        return Keychain(service: "com.cleveroad.Memodo.session")
    }

    func invalidate() throws {
        let keychain = Session.keychain
        try keychain.remove(KeychainKey.session)
    }

    func save() throws {
        let keychain = Session.keychain
        let data = try JSONEncoder().encode(self)
        keychain[data: KeychainKey.session] = data
    }

    static func fetch() -> Session? {
        let keychain = Session.keychain

        do {
            guard let data = try keychain.getData(KeychainKey.session) else { return nil }
            return try? JSONDecoder().decode(Session.self, from: data)
        } catch {
            return nil
        }
    }
}
