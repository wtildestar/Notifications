//
//  Notifications.swift
//  Notifications
//
//  Created by wtildestar on 18/12/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
        
        // uid для категории действий
        let userAction = "User Action"
        
        content.title = notificationType
        content.body = "This is example how to create" + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        content.threadIdentifier = notificationType
        content.summaryArgumentCount = 10
        content.summaryArgument = notificationType
        
        guard let path = Bundle.main.path(forResource: "notify", ofType: "png") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(
                identifier: "notify",
                url: url,
                options: nil)
            
            content.attachments = [attachment]
        } catch {
            print("The attachment could not be loaded")
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // позволяет определять идентификатор сообщения для группировки уведомлений
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // действия пользователя в уведомлении
        let actions = [
            UNNotificationAction(identifier: "Snooze", title: "Snooze", options: []),
            UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        ]
        
        // создаю категории для действий
//        let category = UNNotificationCategory(identifier: userAction,
//                                              actions: [snoozeAction, deleteAction],
//                                              intentIdentifiers: [],
//                                              options: [])
        let category = UNNotificationCategory(
            identifier: userAction,
            actions: actions,
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: nil,
            categorySummaryFormat: "%u новых уведомлений в разделе %@",
            options: [])
        // регистрирую категорию в центре уведомлений
        notificationCenter.setNotificationCategories([category])
    }
    
    // метод срабатывает когда приложение на переднем плане
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // обработка события на реагирование уведомления
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the local Notification Identifier")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
}
