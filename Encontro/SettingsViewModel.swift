//
//  ProfileViewModel.swift
//  ChatApp
//
//  Created by k on 2024-02-16.
//

import Foundation

enum SettingsViewModel: Int, CaseIterable, Identifiable {
    case activeStatus
    case privacy
    case notifications
    
    var title: String{
        switch self{
        case .activeStatus: return "Active"
        case .privacy: return "Privacy"
        case .notifications: return "Notifications"
        }
    }
    
    var imageName: String{
        switch self{
        case .activeStatus: return "message.badge.circle.fill"
        case .privacy: return "lock.circle.fill"
        case .notifications: return "bell.circle.fill"
        }
    }
    
    var id: Int {return self.rawValue}
}
