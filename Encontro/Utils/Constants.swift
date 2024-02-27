//
//  Constants.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import Foundation
import Firebase

struct AppConstants {
    static let UserCollection =  Firestore.firestore().collection("users")
    static let MessagesCollection =  Firestore.firestore().collection("messages")
}
