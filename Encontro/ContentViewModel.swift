//
//  ContentViewModel.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import Foundation
import Firebase
import Combine

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(){
        subscribe()
    }
    
    private func subscribe(){
        AuthenticationService.shared.$userSession.sink { [weak self] firebaseUserSession in
            self?.userSession = firebaseUserSession
        }.store(in: &subscriptions)
    }
}
