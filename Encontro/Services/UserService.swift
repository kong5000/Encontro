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
    //TODO: Add listener to user doc to update on matches for partner
    @Published var currentUser: User?
    @Published var currentPartner: User?
    
    static let shared = UserService()
    
    init() {
        subscribeToUserDocChanges()
    }
    
    func subscribeToUserDocChanges () {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        AppConstants.UserCollection.document(uid).addSnapshotListener { snapshot, error in
            guard let document = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            do{
                let user = try snapshot?.data(as: User.self)
                self.currentUser = user
                if let sharedUserDefaults = UserDefaults(suiteName: "group.com.keith.Encontro") {
                    sharedUserDefaults.set(user?.id, forKey: "uid")
                    print("saved in defaults")
                }
                
                
                
                if let partnerId = user?.partnerId {
                    UserService.fetchUser(withUid: partnerId) { partner in
                        self.currentPartner = partner
                    }
                }
            }catch{
                print("Error decoding user \(error)")
            }
            return
        }
    }
    
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
    
    static func fetchUserAsync (withUid uid: String) async throws -> User? {
        do {
            let document = try await AppConstants.UserCollection.document(uid).getDocument()
            if document.exists {
                guard let user = try? document.data(as: User.self) else { return nil}
                return user
            } else {
                print("Document does not exist")
                return nil
            }
        } catch {
            print("Error writing document: \(error)")
            return nil
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

