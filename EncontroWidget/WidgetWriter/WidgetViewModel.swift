//
//  WidgetViewModel.swift
//  Encontro
//
//  Created by k on 2024-02-29.
//

import Foundation
import FirebaseFirestore

class WidgetViewModel: ObservableObject {
    private var db = Firestore.firestore()

    func updateOrCreateWidgetData(userId: String, widgetData: [String: Any]) {
        let docRef = db.collection("widgetMessages").document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, update it
                docRef.updateData(widgetData) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            } else {
                // Document does not exist, create it
                docRef.setData(widgetData) { error in
                    if let error = error {
                        print("Error writing document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully written")
                    }
                }
            }
        }
    }
}
