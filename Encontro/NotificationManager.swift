//
//  NotificationManager.swift
//  CartaChat
//
//  Created by k on 2024-02-26.
//

import Foundation
import UserNotifications

@MainActor
class NotificationManager{
    static func request() async{
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch{
            print(error)
        }
    }
}
