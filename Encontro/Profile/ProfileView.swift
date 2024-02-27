//
//  ProfileView.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import SwiftUI
import PhotosUI
struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    let user: User
    var body: some View {
        VStack{
            VStack{
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let profileImage = viewModel.profileImage {
                        profileImage
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else{
                        ProfileImageView(user: user, size: .large)
                    }
                    
                }
                Text(user.screenName)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            List{
                Section{
                    ForEach(SettingsViewModel.allCases){option in
                        HStack{
                            Image(systemName: option.imageName)
                                .resizable()
                                .frame(width:24, height:24)
                            Text(option.title)
                            
                        }
                    }
                }
                Section{
                    Button("Log Out"){
                        AuthenticationService.shared.signOut()
                    }
                    Button("Delete Account"){
                        
                    }
                }
                .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER)
}
