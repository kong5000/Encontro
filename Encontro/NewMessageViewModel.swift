//
//  RequestViewModel.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import Foundation
import Firebase

class NewMessageViewModel: ObservableObject {
    @Published var users = [User]()
    
    init(){
        Task { try await fetchUsers() }
    }
    
    @MainActor
    func fetchUsers () async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let fetchedUsers = try await UserService.fetchAllUsers()
        self.users = fetchedUsers.filter({$0.id != currentUid})
    }
}
