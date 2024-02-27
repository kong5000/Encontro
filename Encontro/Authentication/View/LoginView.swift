//
//  LoginView.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Text("🌎")
                    .font(.system(size: 100))
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                VStack(spacing : 12){
                    TextField("Email", text: $viewModel.email)
                        .font(.subheadline)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray6), lineWidth: 2)
                        )
                        .padding(.horizontal, 24)

                    SecureField("Password", text: $viewModel.password)
                        .font(.subheadline)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray6), lineWidth: 2)
                        )
                        .padding(.horizontal, 24)
                }
                
                Button {
                   print("Forgot password pressed")
                } label: {
                    Text("Forgot password")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 29)
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                
                Button{
                    Task{ try await viewModel.login()}
                }label:{
                    Text("Login")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 44)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 24)

                }
                .padding(.vertical)
                
                Spacer()
                NavigationLink{
                    RegistrationView()
                } label: {
                    HStack(spacing: 3){
                        Text("No Account? ")
                        Text("Sign up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    LoginView()
}
