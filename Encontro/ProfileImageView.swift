//
//  ProfileImageView.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import SwiftUI
import SDWebImageSwiftUI

enum ProfileImageSize {
    case small
    case medium
    case large
    
    var dimension: CGFloat {
        switch self {
        case.small: return 40
        case.medium: return 56
        case.large: return 64
        }
    }
}

struct ProfileImageView: View {
    var user: User?
    let size: ProfileImageSize
    var body: some View {
        if let imageUrl = user?.profileImageUrl{
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }else{
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundColor(Color(.systemGray))
        }
    }
}

#Preview {
    ProfileImageView(user: User.MOCK_USER, size: .medium)
}
