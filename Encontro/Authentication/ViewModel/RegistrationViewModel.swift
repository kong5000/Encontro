//
//  RegistrationViewModel.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var screenName = ""
    
    func createUser() async throws {
        try await AuthenticationService.shared.createUser(withEmail: email, password: password, screenName: screenName)
    }
}
