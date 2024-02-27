//
//  ChatBubble.swift
//  CartaChat
//
//  Created by k on 2024-02-24.
//

import SwiftUI

struct ChatBubble: Shape {
    let fromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path{
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, fromCurrentUser ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
    
}

#Preview {
    ChatBubble(fromCurrentUser: true)
}
