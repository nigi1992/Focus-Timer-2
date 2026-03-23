//
//  NotificationManager.swift
//  Focus Timer 2
//
//  Created by Codex on 23.03.2026.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private let timerNotificationID = "focus-timer-finished"

    private init() {}

    //func requestAuthorization() {
        //   UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, //_ in }
        //}
    func requestAuthorization() {
        // Bail out if running in a test/preview context with no valid bundle
        guard Bundle.main.bundleIdentifier != nil else { return }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error { print("Auth error: \(error)") }
        }
    }
    func scheduleTimerFinishedNotification(after seconds: TimeInterval, enabled: Bool) {
        cancelTimerNotifications()
        guard enabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Focus session finished"
        content.body = "Your timer is done. Come back and claim your earnings."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
        let request = UNNotificationRequest(identifier: timerNotificationID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelTimerNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [timerNotificationID])
    }
}
