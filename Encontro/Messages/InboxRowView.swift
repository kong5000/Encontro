//
//  InboxRowView.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import SwiftUI

struct InboxRowView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            ProfileImageView(user: message.user, size: .medium)
            VStack(alignment: .leading){
                Text(message.user?.screenName ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(message.messageText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            Text(message.timestampString)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .frame(height: 72)
    }
}
