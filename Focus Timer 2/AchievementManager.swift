//
//  Achievement.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//


// Achievement system - Tracking and unlocking achievements

import SwiftUI
import Combine

enum Achievement: String, CaseIterable, Identifiable, Codable {
    case firstFocus = "First Focus"
    case earlyBird = "Early Bird"
    case moneyMaker = "Money Maker"
    case architect = "Architect"
    case cityPlanner = "City Planner"
    case marathonFocus = "Marathon Focus"
    case centuryClub = "Century Club"
    case villageFounder = "Village Founder"
    case treasureHunter = "Treasure Hunter"
    case dedicated = "Dedicated"
    case easterEggFinder = "Secret Explorer"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .firstFocus:
            return "Complete your first focus session"
        case .earlyBird:
            return "Complete a focus session before 8 AM"
        case .moneyMaker:
            return "Earn $100 total"
        case .architect:
            return "Build your first building"
        case .cityPlanner:
            return "Build 10 buildings"
        case .marathonFocus:
            return "Complete a 120 minute focus session"
        case .centuryClub:
            return "Accumulate 100 total focus minutes"
        case .villageFounder:
            return "Reach a population of 50"
        case .treasureHunter:
            return "Earn $500 total"
        case .dedicated:
            return "Complete 25 focus sessions"
        case .easterEggFinder:
            return "Find the hidden secret"
        }
    }
    
    var emoji: String {
        switch self {
        case .firstFocus: return "🎯"
        case .earlyBird: return "🌅"
        case .moneyMaker: return "💰"
        case .architect: return "🔨"
        case .cityPlanner: return "🏗️"
        case .marathonFocus: return "🏃"
        case .centuryClub: return "💯"
        case .villageFounder: return "👥"
        case .treasureHunter: return "💎"
        case .dedicated: return "⭐"
        case .easterEggFinder: return "🥚"
        }
    }
    
    var reward: Int {
        switch self {
        case .firstFocus: return 5
        case .earlyBird: return 15
        case .moneyMaker: return 20
        case .architect: return 10
        case .cityPlanner: return 50
        case .marathonFocus: return 60
        case .centuryClub: return 25
        case .villageFounder: return 30
        case .treasureHunter: return 100
        case .dedicated: return 75
        case .easterEggFinder: return 50
        }
    }
}

class AchievementManager: ObservableObject {
    @Published var unlockedAchievements: Set<Achievement> = []
    @Published var recentlyUnlocked: Achievement?
    @Published var showNotification: Bool = false
    
    // Stats tracking
    @Published var totalSessions: Int = 0
    @Published var totalEarnings: Int = 0
    
    // Checking and unlocking an achievement
    func unlock(_ achievement: Achievement, gameState: GameState) {
        guard !unlockedAchievements.contains(achievement) else { return }
        
        unlockedAchievements.insert(achievement)
        recentlyUnlocked = achievement
        showNotification = true
        
        // Awarding bonus money
        gameState.money += achievement.reward
        
        // Hiding notification after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showNotification = false
            self.recentlyUnlocked = nil
        }
    }
    
    // Checking all achievement conditions
    func checkAchievements(gameState: GameState) {
        // First Focus
        if gameState.totalFocusSeconds > 0 {
            unlock(.firstFocus, gameState: gameState)
        }
        
        // Early Bird - session completed before 8 AM
        let hour = Calendar.current.component(.hour, from: Date())
        //if hour < 8 && gameState.totalFocusSeconds > 0 {
        if hour < 20 && gameState.totalFocusSeconds > 0 {
            unlock(.earlyBird, gameState: gameState)
        }
        
        // Money Maker - earned $100 total
        if totalEarnings >= 10 {//100 {
            unlock(.moneyMaker, gameState: gameState)
        }
        
        // Marathon Focus - completed 120 min session
        //if gameState.selectedSeconds >= 120 && !gameState.isTimerRunning &&
        if gameState.selectedSeconds >= 12 && !gameState.isTimerRunning && gameState.totalFocusSeconds >= 12 {//120 {
            unlock(.marathonFocus, gameState: gameState)
        }
        
        // Century Club - 100 total focus minutes
        if gameState.totalFocusSeconds >= 20 {//100 {
            unlock(.centuryClub, gameState: gameState)
        }
        
        // Village Founder - population of 50
        if gameState.population >= 10 {//50 {
            unlock(.villageFounder, gameState: gameState)
        }
        
        // Treasure Hunter - earned $500 total
        if totalEarnings >= 120 {//500 {
            unlock(.treasureHunter, gameState: gameState)
        }
        
        // Dedicated - 25 sessions completed
        if totalSessions >= 5 {//25 {
            unlock(.dedicated, gameState: gameState)
        }
    }
    
    // Called when a session completes
    func recordSessionComplete(earnings: Int, gameState: GameState) {
        totalSessions += 1
        totalEarnings += earnings
        checkAchievements(gameState: gameState)
    }
    
    // MARK: - Building Achievements
    
    // Architect - built first building
    func checkArchitectAchievement(gameState: GameState) {
        if gameState.completedBuildings.count >= 1 {
            unlock(.architect, gameState: gameState)
        }
    }
    
    // City Planner - built 10 buildings
    func checkCityPlannerAchievement(gameState: GameState) {
        if gameState.completedBuildings.count >= 10 {
            unlock(.cityPlanner, gameState: gameState)
        }
    }
    
    // MARK: - Special Achievements
    
    // Easter egg achievement - called separately
    func unlockEasterEgg(gameState: GameState) {
        print("Easter egg unlock triggered") // Debug line
        unlock(.easterEggFinder, gameState: gameState)
    }

    // Progress calculation for display
    func progress() -> (unlocked: Int, total: Int) {
        return (unlockedAchievements.count, Achievement.allCases.count)
    }
}
