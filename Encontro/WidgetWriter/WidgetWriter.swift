//
//  WidgetWriter.swift
//  Encontro
//
//  Created by k on 2024-03-01.
//

import SwiftUI

struct WidgetWriter: View {
    @StateObject var viewModel = WidgetWriterViewModel()
    
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Text(viewModel.text)
                    .font(.system(size: 20))
                    .padding()
                Text(viewModel.emoji)
                    .font(.system(size: 75))
                    .padding()
            }
            .frame(width: 300, height: 125) // Adjusted height for better visibility
            .background(RoundedRectangle(cornerRadius: 20).fill(viewModel.selectedColor))
            Form {
                Section(header: Text("Widget Parameters")) {
                    TextField("Text", text: $viewModel.text)
                        .padding()
                    
                    TextField("Emoji", text: $viewModel.emoji)
                        .padding()
                        .onChange(of: viewModel.emoji) { newValue in
                            if newValue.count > 1 {
                                viewModel.emoji = String(newValue.prefix(1))
                            }
                        }
                    
                    ColorPicker("Select Color", selection: $viewModel.selectedColor)
                        .padding()
                }
                Button{
                    Task{
                        await viewModel.submit()
                    }
                }
            label: {
                Text("submit")
            }
            .disabled(viewModel.isLoading)
                
            }
            
        }
        
    }
}


#Preview {
    WidgetWriter()
}
