//
//  ProfileSettingsViewModel.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import Foundation
import Combine

class ProfileSettingsViewModel: ObservableObject {
    @Published var currentUser: User?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(){
        subscribe()
    }
    
    private func subscribe(){
        UserService.shared.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }.store(in: &subscriptions)
    }
}
