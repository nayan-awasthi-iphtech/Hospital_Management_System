//
//  NotificationManager.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 17/07/26.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
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
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: triggerDate)
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
    
    func cancelNotification(id: String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[id])
        print("Cancel pending Notification with id: \(id)")
    }
}
