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
        GeometryReader { geometry in
            VStack{
                HStack{
                    Text("Partner Widget Preview")
                        .font(.system(size: 30))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    Spacer()
                }
                
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
                
                
                HStack(spacing: 10){
                    TextField("Message", text: $viewModel.text, axis: .vertical)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray6), lineWidth: 2)
                        )
                    TextField("Enter an emoji 😊", text: $viewModel.emoji)
                        .padding(12)
                        .frame(width: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray6), lineWidth: 2)
                        )
                    
                }
                .frame(width: geometry.size.width * 9 / 10)
                .padding()
                
                ColorPicker("Background Color", selection: $viewModel.selectedColor)
                    .padding(12)
                    .foregroundColor(.gray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray6), lineWidth: 2)
                    )
                    .frame(width: geometry.size.width * 9 / 10)
                    .padding()
                Button{
                    Task{
                        await viewModel.submit()
                    }
                }
            label: {
                Text("Submit")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(ThemeManager.themeColor)
                    .cornerRadius(10)
                    .frame(width: geometry.size.width * 9 / 10)
                    .padding()
            }
            .disabled(viewModel.isLoading)
                
            }
        }
    }
}


#Preview {
    WidgetWriter()
}
