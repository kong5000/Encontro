//
//  AddEntryViewModel.swift
//  Encontro
//
//  Created by k on 2024-02-29.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import FirebaseStorage

class AddEntryViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    
    @Published var newEntryTitle = ""
    @Published var newEntryText = ""
    @Published var date = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func submitEntry(date: Date) async throws {
        
        isLoading = true
        errorMessage = nil
        
        var imageUrl: String? = nil
        
        if let selectedItem {
            imageUrl = try await uploadImage()
        }
        
        let newEntry = Entry(title: newEntryTitle, text: newEntryText, imageUrl: imageUrl, date: date)
        do{
            try await CalendarService.uploadEntry(newEntry)
            isLoading = false
        }catch{
            errorMessage = "Error uploading entry"
        }
    }
    
    func uploadImage() async throws -> String {
        guard let item = selectedItem else {
            throw NSError(domain: "AddEntryViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "No image selected."])
        }
        
        guard let imageData = try await item.loadTransferable(type: Data.self) else {
            throw NSError(domain: "AddEntryViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to load image."])
        }
        
        guard let currentUid = Auth.auth().currentUser?.uid, let matchId = UserService.shared.matchId else {
            throw NSError(domain: "AddEntryViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "User not authenticated or match ID missing."])
        }
        
        let storageRef = Storage.storage().reference().child("\(matchId)/\(UUID().uuidString).jpg")
        
        return try await uploadData(imageData, to: storageRef)
    }
    
    private func uploadData(_ data: Data, to storageRef: StorageReference) async throws -> String {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        try await storageRef.putDataAsync(data, metadata: metadata)
        
        let url = try await storageRef.downloadURL().absoluteString

        return url
    }
    
}
