//
//  MatchPartnerView.swift
//  Encontro
//
//  Created by k on 2024-02-27.
//

import SwiftUI

struct MatchView: View {
    @State private var partnerCode = ""
    @StateObject private var viewModel = MatchViewModel()
    
    var body: some View {
        VStack{
            if let currentUserId = viewModel.currentUser?.id {
                Text("Your match code is: ")
                Text(currentUserId)
                ShareLink(item: currentUserId)
                
                Spacer()
                Text("Or Enter a match code")
                TextField("Partner Code", text: $partnerCode)
                    .padding()
                    .background()
                
                Button{
                    Task{ try await viewModel.match(with: partnerCode) }
                } label: {
                    Text("Connect")
                }
                
            }else{
                Text("Error MEssage")
            }
            
            
            
        }
    }
}

#Preview {
    MatchView()
}
