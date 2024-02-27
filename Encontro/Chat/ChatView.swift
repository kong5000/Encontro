//
//  ChatView.swift
//  CartaChat
//
//  Created by k on 2024-02-24.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    let user: User?
    
    init(user: User){
        print(user)
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    
    var body: some View {
        VStack{
            Text(user!.screenName)
            ScrollViewReader { value in
                ScrollView{
                    LazyVStack{
                        ForEach(Array(viewModel.messages.enumerated()), id:\.element)
                        { idx, message  in
                            ChatRow(message: message).id(idx)
                        }
                 
                        .onChange(of: viewModel.messages.count) {
                            value.scrollTo(viewModel.messages.count - 1,  anchor: .bottom)
                        }
                    }
      
                }
            }
            
            Spacer()
            ZStack(alignment: .bottom){
                HStack(spacing: 12){
                    TextField("Message", text: $viewModel.messageText, axis: .vertical)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray6), lineWidth: 2)
                        )
                    Button{
                        viewModel.sendMessage()
                    } label: {
                        Text("Send")
                    }
                    .padding(12)
                    .foregroundColor(.white)
                    .background(.blue)
                    .clipShape(Capsule())
                }
                .padding(12)
                
            }
        }
    }
}

#Preview {
    ChatView(user: User.MOCK_USER)
}
