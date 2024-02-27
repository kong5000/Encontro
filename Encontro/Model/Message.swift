//
//  Message.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import Foundation
import Firebase

struct Message: Identifiable, Codable, Hashable {
    var id: String
    let fromId: String
    let toId: String
    let messageText: String
    let timestamp: Timestamp
    
    var user: User?
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var timestampString: String {
        return timestamp.dateValue().timestampString()
    }
    
    var chatPartnerId: String{
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}

