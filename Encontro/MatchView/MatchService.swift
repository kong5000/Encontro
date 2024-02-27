//
//  MatchService.swift
//  Encontro
//
//  Created by k on 2024-02-27.
//

import Foundation

class MatchService {
    static func match (with partnerId: String) async throws {
        //Check if user exists
        UserService.fetchUser(withUid: partnerId) { partner in
            print(partner.screenName)
        }
    }
}
