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
                        TabView{
                            ChatView(user: partner)
                                .tabItem {
                                    Label("Chat", systemImage: "message")
                                }
                            WidgetWriter()
                                .tabItem {
                                    Label("Widget", systemImage: "rectangle.and.pencil.and.ellipsis")
                                    
                                }
                            ProfileView(user: currentUser)
                                .tabItem {
                                    Label("Profile", systemImage: "person.circle.fill")
                                }
                        }
                        .accentColor(ThemeManager.themeColor)
                        .onAppear{
                            Task { await NotificationManager.request() }
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
