//
//  AuthenticationService.swift
//  CartaChat
//
//  Created by k on 2024-02-24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthenticationService{
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthenticationService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
    }
    
    @MainActor
    func login(withEmail email: String, password: String ) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
        }catch{
            print("Could not sign in \(error)")
        }
    }
    
    @MainActor
    func signOut(){
        do{
            try Firebase.Auth.auth().signOut()
            self.userSession = nil
            UserService.shared.currentUser = nil
            print("Signed out")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, screenName:String ) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(email: email, screenName: screenName, id: result.user.uid)
            loadCurrentUserData()
            print("User Created \(result.user.uid)")
        }catch{
            print("\(error.localizedDescription)")
        }
    }
    
    private func uploadUserData (email: String, screenName: String, id:String) async throws{
        let user = User(id: id, screenName: screenName, email: email, profileImageUrl: nil)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    private func loadCurrentUserData(){
        Task{ try await UserService.shared.fetchUserData() }
    }
}
