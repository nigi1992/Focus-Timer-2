//
//  FocusIslandApp.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 30.01.2026.
//


// Focus Island - A productivity timer that builds communities
// Main app entry point

import SwiftUI

@main
struct FocusIslandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var gameState = GameState()
    @StateObject private var achievementManager = AchievementManager()
    @StateObject private var settingsManager = SettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.frame(minWidth: 700, minHeight: 1000)
                .environmentObject(gameState)
                .environmentObject(achievementManager)
                .environmentObject(settingsManager)
                .preferredColorScheme(settingsManager.darkModeEnabled ? .dark : .light)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                    SoundFeedbackManager.shared.configure(settingsManager: settingsManager)
                }
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification)) { _ in
                    // Detecting when user leaves the app during active timer
                    gameState.handleAppBackground()
                }
                .onReceive(NotificationCenter.default.publisher(for: .sessionCompleted)) { notification in
                    // Triggering achievement check when session completes
                    if let earnings = notification.userInfo?["earnings"] as? Int {
                        achievementManager.recordSessionComplete(earnings: earnings, gameState: gameState)
                    }
                    NotificationManager.shared.cancelTimerNotifications()
                    SoundFeedbackManager.shared.play(event: .timerCompleted)
                }
                .onReceive(NotificationCenter.default.publisher(for: .buildingPurchased)) { _ in
                                    // Checking building achievements when a building is purchased
                    achievementManager.checkArchitectAchievement(gameState: gameState)
                    achievementManager.checkCityPlannerAchievement(gameState: gameState)
                }
        }
        .windowStyle(.automatic)
        //.windowStyle(.hiddenTitleBar)
        //.windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
