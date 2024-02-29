//
//  CalendarViewModel.swift
//  Encontro
//
//  Created by k on 2024-02-28.
//

import Foundation

struct Entry: Codable {
    var title: String
    var text: String
    var date: Date {
        didSet {
            updateMonthAndDay()
        }
    }
    var imageUrl: String?
    
    var month: Int
    var day: Int
    
    init(title: String, text: String, imageUrl: String?, date: Date) {
        self.title = title
        self.text = text
        self.imageUrl = imageUrl
        self.date = date
        
        self.month = 0
        self.day = 0
        updateMonthAndDay()
    }
    
    mutating func updateMonthAndDay() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        month = components.month ?? 0
        day = components.day ?? 0
    }
}

class CalendarViewModel: ObservableObject {
    @Published var entries = [Entry]()
    @Published var newEntryTitle = ""
    @Published var newEntryText = ""
    @Published var newEntryImageUrl: String?
    @Published var date = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        CalendarService.fetchUserEntries { entries in
            self.entries = entries
        }
    }
    
    
    func addEntry() {
        let entry = Entry(title: newEntryTitle, text: newEntryText, imageUrl: newEntryImageUrl, date: date)
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await CalendarService.uploadEntry(entry)
                CalendarService.fetchUserEntries { newEntries in
                    self.entries = newEntries
                    DispatchQueue.main.async { [weak self] in
                        self?.isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
