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
                if hasPartner{
                    InboxView()
                } else{
                    MatchView()
                }
            }else{
                
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
