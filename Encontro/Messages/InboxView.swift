//
//  InboxView.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import SwiftUI

struct InboxView: View {
    @State private var showRequestsView = false
    @StateObject private var viewModel = InboxViewModel()
    
    @State private var selectedUser: User?
    @State private var showNewMessageView = false
    @State private var showChat = false
    
    @StateObject var notificationManager = NotificationManager()
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Button("Request Notification"){
                    Task{
                        await notificationManager.request()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(notificationManager.hasPermission)
                .task {
                    await notificationManager.getAuthStatus()
                }
                List{
                    ForEach(viewModel.recentMessages){ message in
                        NavigationLink(value: message){
                            InboxRowView(message: message)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                Spacer()
            }
            .onChange(of: selectedUser){
                showChat = selectedUser != nil
            }
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    ChatView(user: user)
                }else{
                    Text("Message missing")
                    Text(message.messageText)
                }
            })
            .fullScreenCover(isPresented: $showNewMessageView, content: {
                NewMessageView(selectedUser: $selectedUser)
            })
            .navigationDestination(isPresented: $showChat, destination: {
                if let chatPartnerUser = selectedUser {
                    ChatView(user: chatPartnerUser)
                }
            })
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    HStack{
                        NavigationLink(
                            destination: ProfileView(user: user ?? User.MOCK_USER),
                            label: {
                                ProfileImageView(user: user, size: .small)
                            }
                        )
                        Text("Chats")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        showNewMessageView.toggle()
                        selectedUser = nil
                    }label : {
                        Image(systemName:  "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 32, height:32)
                        
                    }
                }
            }
        }
    }
}

#Preview {
    InboxView()
}
