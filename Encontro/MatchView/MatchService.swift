//
//  MatchService.swift
//  Encontro
//
//  Created by k on 2024-02-27.
//

import Foundation
import Firebase

class MatchService {
    //TODO: Error handling
    //TODO: Don't let user match with theirself
    static func match (with partnerId: String) async throws {
        //Check if user exists
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        if partnerId == currentUserId {
            //User has attempted to match with themselves
            return
        }
        guard let partner = try await UserService.fetchUserAsync(withUid: partnerId) else { return }
        
        try await Firestore.firestore().collection("users")
            .document(currentUserId)
            .updateData(["partnerId" : partnerId])
        
        try await Firestore.firestore().collection("users")
            .document(partnerId)
            .updateData(["partnerId" : currentUserId])
        
        try await UserService.shared.fetchUserData()
    }
}
