//
//  AddCalendarEntry.swift
//  Encontro
//
//  Created by k on 2024-02-29.
//

import SwiftUI
import PhotosUI

struct AddEntryView: View {
    @StateObject private var viewModel = AddEntryViewModel()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    var date: Date
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entry Details")) {
                    TextField("Title", text: $viewModel.newEntryTitle)
                    TextField("Text", text: $viewModel.newEntryText)
                }
                
                Section(header: Text("Image")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text(viewModel.selectedItem == nil ? "Select Image" : "Change Image")
                    }
                    if let inputImage = inputImage {
                        Image(uiImage: inputImage)
                            .resizable()
                            .scaledToFit()
                    }
                }
                
                Section {
                    Button("Submit Entry") {
                        Task {
                            try await viewModel.submitEntry(date: date)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .navigationTitle("Add New Entry")
            .disabled(viewModel.isLoading)
            .alert("Error", isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), actions: {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            }, message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                PhotosPicker(selection: $viewModel.selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")
                }
            }
        }
    }
    private func loadImage() {
        Task {
            guard let selectedItem = viewModel.selectedItem else { return }
            if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                inputImage = UIImage(data: data)
            }
        }
    }
}

