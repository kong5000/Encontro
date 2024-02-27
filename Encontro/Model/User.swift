//
//  User.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import Foundation

struct User: Codable, Identifiable, Hashable{
    var id: String
    let screenName: String
    let email: String
    var profileImageUrl: String?
}

extension User {
    static let MOCK_USER = User(id: UUID().uuidString, screenName: "Test User", email:"test@test.com", profileImageUrl: nil)
}
