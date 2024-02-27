//
//  UserListViewModel.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import Foundation
import Firebase

class UserListViewModel: ObservableObject {
    @Published var users = [User]()
    
    init(){
        Task{try await fetchUsers()}
    }
    
    @MainActor
    func fetchUsers() async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        
        //Do not allow user to chat with themself
        self.users = users.filter({$0.id != currentUserId})
    }
}
