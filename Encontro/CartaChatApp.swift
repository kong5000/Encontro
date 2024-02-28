//
//  CartaChatApp.swift
//  CartaChat
//
//  Created by k on 2024-02-23.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("\(teamId)keith.Encontro.EncontroWidget")
        }catch{
            print(error)
        }
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
            
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
            print("fcm saved", fcm)

        }
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
