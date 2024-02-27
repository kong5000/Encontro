//
//  ContentView.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group{
            if viewModel.userSession != nil {
                InboxView()
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
