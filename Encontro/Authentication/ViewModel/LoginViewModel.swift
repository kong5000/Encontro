//
//  LoginViewModel.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        try await AuthenticationService.shared.login(withEmail: email, password: password)
    }
}
