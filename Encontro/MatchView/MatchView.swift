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
                Text("Find your partner")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(ThemeManager.themeColor)
                Text("Share your code with your partner")
                    .padding()
                
                ShareLink(item: currentUserId) {
                    Text("Share")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(ThemeManager.themeColor)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                HStack{
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 50, height: 0.5)
                    Text("Or")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 50, height: 0.5)
                }.foregroundColor(.gray)
                
                Spacer()

                Text("Or enter your partner's code")
                    .padding()
                TextField("Partner Code", text: $partnerCode, axis: .vertical)
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ThemeManager.themeColor, lineWidth: 2)
                    )
                    .padding()
                Button{
                    Task{ try await viewModel.match(with: partnerCode) }
                } label: {
                    Text("Connect")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(ThemeManager.themeColor)
                        .cornerRadius(10)
                }
                Spacer()
                
            }else{
                Text("Error MEssage")
            }
            
            
            
        }
    }
}

#Preview {
    MatchView()
}
