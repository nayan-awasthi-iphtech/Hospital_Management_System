//
//  NotificationManager.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 17/07/26.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted!")
            } else if let error = error {
                print("Error in requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    func ScheduleNotification(
        id: String,
        title: String,
        body: String,
        targetDate: Date,
        minutesBefore: Int = 60
    ){
        guard let triggerDate = Calendar.current.date(byAdding: .minute, value: -minutesBefore, to: targetDate) else { return }
        
        guard triggerDate > Date() else {
            print("Trigger! date is already passed away")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error in scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification is scheduled for \(triggerDate.formatted())")
            }
        }
    }
    func sendInstantNotification(
        id: String,
        title: String,
        body: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // FIXED: Set timeInterval to 1 (0 causes an immediate crash)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending instant notification: \(error.localizedDescription)")
            } else {
                print("Instant notification sent successfully!")
            }
        }
    }
    func cancelNotification(id: String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[id])
        print("Cancel pending Notification with id: \(id)")
    }
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            completionHandler([.banner, .sound, .badge])
        }
}
