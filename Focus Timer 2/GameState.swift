//
//  GameState.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 30.01.2026.
//


// GameState - Managing island progress, currency, and timer logic

import SwiftUI
import Combine

class GameState: ObservableObject {
    // Timer settings (1-120 minutes)
    //@Published var selectedMinutes: Int = 25
    @Published var selectedSeconds: Int = 25
    @Published var remainingSeconds: Int = 0
    @Published var isTimerRunning: Bool = false
    
    // Currency system - 1 minute = $1
    @Published var money: Int = 0
    @Published var pendingEarnings: Int = 0
    
    // Island/Community progress
    //@Published var totalFocusMinutes: Int = 0
    @Published var totalFocusSeconds: Int = 0
    @Published var completedBuildings: [Building] = []
    @Published var population: Int = 0
    @Published var islandLevel: Int = 1
    
    // Session tracking
    @Published var currentSessionProgress: Double = 0
    @Published var sessionViolated: Bool = false
    
    private var timer: AnyCancellable?
    //private var elapsedMinutes: Int = 0
    private var elapsedSeconds: Int = 0
    
    // Building costs in dollars (same as minutes)
    let buildingCosts: [BuildingType: Int] = [
        .tent: 1,
        .hut: 2,//15,
        .house: 3,//30,
        .farm: 4,//45,
        .market: 5,//60,
        .library: 6,//90,
        .townHall: 7,//120,
        .lighthouse: 8,//180,
        .castle: 9,//300
    ]
    
    func startTimer() {
        guard !isTimerRunning else { return }
        
        //remainingSeconds = selectedMinutes * 60
        remainingSeconds = selectedSeconds
        isTimerRunning = true
        sessionViolated = false
        currentSessionProgress = 0
        pendingEarnings = 0
        //elapsedMinutes = 0
        elapsedSeconds = 0
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func tick() {
        guard remainingSeconds > 0 else {
            completeSession()
            return
        }
        
        remainingSeconds -= 1
        //let totalSeconds = Double(selectedMinutes * 60)
        let totalSeconds = selectedSeconds
        var elapsedSeconds = totalSeconds - remainingSeconds
        currentSessionProgress = Double(elapsedSeconds / totalSeconds)
        
        // Tracking earnings per minute completed
        //let newElapsedMinutes = Int(elapsedSeconds) / 60
        //if newElapsedMinutes > elapsedMinutes {
        //    elapsedMinutes = newElapsedMinutes
        //    pendingEarnings = elapsedMinutes
        //}
        let newElapsedSeconds = Int(elapsedSeconds)
        if newElapsedSeconds > elapsedSeconds {
            elapsedSeconds = newElapsedSeconds
            pendingEarnings = elapsedSeconds
        }
    }
    
    func handleAppBackground() {
        // VIOLATION: User left the app while timer was running
        if isTimerRunning {
            sessionViolated = true
            isTimerRunning = false
            timer?.cancel()
            currentSessionProgress = 0
            pendingEarnings = 0
            //elapsedMinutes = 0
            elapsedSeconds = 0
            // Losing all pending earnings as penalty
        }
    }
    
    func completeSession() {
        timer?.cancel()
        isTimerRunning = false
        
        // Awarding money: 1 minute = $1
        money += selectedSeconds
        totalFocusSeconds += selectedSeconds
        
        pendingEarnings = 0
        elapsedSeconds = 0
        currentSessionProgress = 0
        // Notifying achievement manager (handled via NotificationCenter or direct call)
        NotificationCenter.default.post(
            name: .sessionCompleted,
            object: nil,
            userInfo: ["earnings": selectedSeconds]
            )
    }
    
    func stopTimer() {
        // Manual stop - counts as violation
        handleAppBackground()
    }
    
    // Purchasing a building
    func purchaseBuilding(_ type: BuildingType) -> Bool {
        guard let cost = buildingCosts[type], money >= cost else {
            return false
        }
        
        money -= cost
        let newBuilding = Building(type: type, completedAt: Date())
        completedBuildings.append(newBuilding)
        population += type.populationBonus
        updateIslandLevel()
        
        // Notifying that a building was purchased
        NotificationCenter.default.post(
            name: .buildingPurchased,
            object: nil
        )
        
        return true
    }
    
    func canAfford(_ type: BuildingType) -> Bool {
        guard let cost = buildingCosts[type] else { return false }
        return money >= cost
    }
    
    private func updateIslandLevel() {
        // Leveling up based on total buildings and population
        let newLevel = (completedBuildings.count / 5) + 1
        if newLevel > islandLevel {
            islandLevel = newLevel
        }
    }
}
// Adding notification name extension somewhere in your project:
extension Notification.Name {
    static let sessionCompleted = Notification.Name("sessionCompleted")
    static let buildingPurchased = Notification.Name("buildingPurchased")
}
