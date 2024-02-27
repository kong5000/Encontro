//
//  RequestsView.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import SwiftUI

struct NewMessageView: View {
    @StateObject private var viewModel = NewMessageViewModel()
    @Binding var selectedUser: User?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            ScrollView{
                List{
                    ForEach(viewModel.users){user in
                        Text(user.screenName)
                            .onTapGesture {
                                selectedUser = user
                                dismiss()
                            }
                    }
                    
                }
                .listStyle(PlainListStyle())
                .frame(height:UIScreen.main.bounds.height - 120)
            }
            .navigationTitle("New Message")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
        }

    }
}

#Preview {
    NewMessageView(selectedUser: .constant(User.MOCK_USER))
}
