//
//  CalendarViewModel.swift
//  Encontro
//
//  Created by k on 2024-02-28.
//

import Foundation

struct Entry {
    var date: Date
    var title: String
    var text: String
    var photoUrl : String?
}

class CalendarViewModel: ObservableObject {
    @Published var entries = [Entry(date: Date(), title: "Title", text: "Text")]
}
