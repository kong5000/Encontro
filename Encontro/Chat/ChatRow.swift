//
//  ChatRow.swift
//  CartaChat
//
//  Created by k on 2024-02-24.
//

import SwiftUI

struct ChatRow: View {
    let message: Message
    
    var body: some View {
        HStack{
            if(message.isFromCurrentUser){
                Spacer()
                Text(message.messageText)
                    .font(.subheadline)
                    .padding(12)
                    .background(.blue.opacity(0.25))
                    .clipShape(ChatBubble(fromCurrentUser: message.isFromCurrentUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
            }else{
                Text(message.messageText)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .foregroundColor(.black)
                    .clipShape(ChatBubble(fromCurrentUser: message.isFromCurrentUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .leading)
                Spacer()
            }
        }
        .padding(.horizontal, 12)
    }
}
