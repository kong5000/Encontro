//
//  CalendarService.swift
//  Encontro
//
//  Created by k on 2024-02-29.
//

import Foundation
import FirebaseFirestore

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
}
