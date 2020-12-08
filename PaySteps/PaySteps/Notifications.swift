//
//  Notifications.swift
//  PaySteps
//
//  Created by Ryan Schuller on 11/4/20.
//

import Foundation
import UserNotifications

func sendNotification(title: String, subtitle: String = "", timeUntil: Double = 1.0,
                      sound: UNNotificationSound = .default) {
    let content = UNMutableNotificationContent()
    (content.title, content.subtitle, content.sound) = (title, subtitle, sound)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeUntil, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

func requestNotifPermissions() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
        
    }
}
