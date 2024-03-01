//
//  WidgetWriterViewModel.swift
//  Encontro
//
//  Created by k on 2024-03-01.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import UIKit

struct WidgetMessage: Codable {
    let text: String
    let emoji: String
    let hexColor: String?
}

class WidgetWriterViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var emoji: String = "👻"
    @Published var selectedColor: Color = .blue
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    @MainActor
    func submit() async {
        isLoading = true
        do{
            let widgetMessage = WidgetMessage(text: text, emoji: emoji, hexColor: selectedColor.toHexString())
            print("New message")
            print(widgetMessage)
            guard let encodedwidgetMessage = try? Firestore.Encoder().encode(widgetMessage) else { return }
            
            if let partnerId = UserService.shared.currentUser?.partnerId {
                try await
                Firestore.firestore().collection("widgetMessages").document(partnerId).setData(encodedwidgetMessage)
                isLoading = false

            }
        }catch{
            isLoading = false

            print(error)
        }
 
    }
}


extension Color {
    func toHexString() -> String {
        // Convert Color to UIColor
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Convert to hex string
        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
        return hexString
    }
}
