//
//  CalendarService.swift
//  Encontro
//
//  Created by k on 2024-02-29.
//

import Foundation
import FirebaseFirestore
import Firebase

class CalendarService {
    
    static func uploadEntry(_ entry: Entry) async throws {
        let db = Firestore.firestore()
        
        let entryData = self.dictionaryFromEntry(entry)
        
        guard let matchId = UserService.shared.matchId else {
            throw NSError(domain: "CalendarService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Match ID is nil"])
        }
        
        let documentPath = "matches/\(matchId)/calendarEntries"
        
        _ = try await db.collection(documentPath).addDocument(data: entryData)
    }
    
    private static func dictionaryFromEntry(_ entry: Entry) -> [String: Any] {
        var dict: [String: Any] = [
            "title": entry.title,
            "text": entry.text,
            "date": Timestamp(date: entry.date),
            "month": entry.month,
            "day": entry.day
        ]
        
        if let imageUrl = entry.imageUrl {
            dict["imageUrl"] = imageUrl
        }
        
        return dict
    }
    
    static func fetchUserEntries(completion: @escaping (([Entry]) -> Void)) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        guard let matchId = UserService.shared.matchId else {
            return        }
        
        let collectionPath = "users/\(matchId)/entries"
        
        db.collection(collectionPath).getDocuments { (snapshot, error) in
            if let error = error {
                return
            } else if let snapshot = snapshot {
                let entries = snapshot.documents.compactMap { document -> Entry? in
                    try? document.data(as: Entry.self)
                }
                completion(entries)
            } else {
                return
            }
        }
    }
}
