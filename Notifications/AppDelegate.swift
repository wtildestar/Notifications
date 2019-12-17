//
//  AppDelegate.swift
//  Notifications
//
//  Created by wtildestar on 17/12/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestAuthorization()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // запрашивает у пользователя разрешение на отправку уведомлений
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            // вызываю получение настроек уведомлений приложения
            self.getNotificationSettings()
        }
    }
    
    // запрашивает настройки из центра уведомлений приложения
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    // расписание уведомлений
    func scheduleNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        
        content.title = notificationType
        content.body = "This is example how to create" + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

