//
//  UserListView.swift
//  CartaChat
//
//  Created by k on 2024-02-25.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = UserListViewModel()
    @Binding var selectedUser: User?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            Text("User List View")
            ScrollView{
                ForEach(viewModel.users){ user in
                    VStack{
                        Text(user.screenName)
                    }
                    .onTapGesture {
                        selectedUser = user
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    UserListView(selectedUser: .constant(User.MOCK_USER))
}
