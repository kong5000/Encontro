//
//  ContentView.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    let hasPartner = false
    var body: some View {
        Group{
            if viewModel.userSession != nil {
                if let currentUser = viewModel.currentUser {
                    if let partner = viewModel.currentPartner {
//                        InboxView()
                        TabView{
                            ChatView(user: partner)
                                .tabItem {
                                    Label("First", systemImage: "message")
                                }
                            Text("VIEW")
                                .tabItem {
                                    Label("First", systemImage: "calendar")
                                }
                        }
                    }else{
                        MatchView()
                    }
                }
            } else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
