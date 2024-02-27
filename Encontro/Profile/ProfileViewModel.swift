//
//  ProfileViewModel.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    @Published var profileImage: Image?
    
    init(){
    }
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    
    func loadImage() async throws {
        guard let item = selectedItem else {return}
        guard let imageData = try await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data: imageData) else {return}
        self.profileImage = Image(uiImage: uiImage)
        
        if let currentUid = Auth.auth().currentUser?.uid {
            let storageRef = Storage.storage().reference()
            guard let data = uiImage.jpegData(compressionQuality: 0.8) else {return}
            
            let fileRef = storageRef.child("profiles/\(currentUid).jpg")
            
            let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in
                if error == nil && metadata != nil {
                    fileRef.downloadURL { url, error in
                        guard let urlString = url?.absoluteString else {return}
                        Firestore.firestore().collection("users").document(currentUid).updateData(["profileImageUrl": urlString])
                    }
                }
            }
        }
    }
}
