//
//  MatchViewModel.swift
//  Encontro
//
//  Created by k on 2024-02-27.
//

import Foundation
import Combine

class MatchViewModel: ObservableObject {
    @Published var currentUser: User?
    private var subscriptions = Set<AnyCancellable>()
    

    init(){
        setupSubscribers()
    }
    
    private func setupSubscribers(){
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &subscriptions)
    }
    
    func match(with partnerId: String) async throws {
        try await MatchService.match(with: partnerId)
        //Update user data with matched partner id
        try await UserService.shared.fetchUserData()
    }
}
