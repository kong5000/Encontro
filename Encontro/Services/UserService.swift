//
//  UserService.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import Firebase
import Foundation
import FirebaseFirestoreSwift

class UserService: ObservableObject {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
    func fetchUserData() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await AppConstants.UserCollection.document(uid).getDocument()
        
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
        try await saveUserFcmToken()
    }
    
    @MainActor
    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await AppConstants.UserCollection.getDocuments()
        let users = snapshot.documents.compactMap { try? $0.data(as: User.self)}
        return users
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        AppConstants.UserCollection.document(uid).getDocument { snapshot, err in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
    
    func saveUserFcmToken() async throws {
         guard let fcmToken = UserDefaults.standard.value(forKey: "fcmToken") else{
             return
         }
         print("Token retrieved from defaults", fcmToken)
         var dic = [String: Any]()
         dic["token"] = fcmToken
         dic["timestamp"] = Timestamp()
         guard let currentUserId = currentUser?.id else { return }
         print("User Id found, uploading to firestore")
         try await Firestore.firestore().collection("fcmtokens").document(currentUserId).setData(dic)
     }
}

