//
//  ContentView.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 30.01.2026.
//

// Main UI - Timer and Island View

// Main UI - Timer, Island, and Building Shop

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var achievementManager: AchievementManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showShop: Bool = false
    @State private var showCredits: Bool = false
    @State private var showAchievements: Bool = false
    @State private var showSettings: Bool = false
    @State private var showEasterEgg: Bool = false
    @State private var showHamburgerMenu: Bool = false
    @State private var easterEggTapCount: Int = 0
    
    var body: some View {
        ZStack {
            // Background gradient representing sky/ocean
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color.indigo.opacity(0.7), Color.black.opacity(0.85)]
                    : [Color.blue.opacity(0.3), Color.cyan.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Top bar with hamburger menu and settings
                TopBarView(
                    showHamburgerMenu: $showHamburgerMenu,
                    showSettings: $showSettings,
                    showShop: $showShop,
                    showCredits: $showCredits,
                    showAchievements: $showAchievements
                )
                // Island header with stats
                //IslandHeaderView(showShop: $showShop, showCredits: $showCredits, showAchievements: $showAchievements
                //)
                
                Spacer()
                
                
                // Island visualization
                IslandView()
                
                Spacer()
                
                // Timer controls
                TimerControlView()
                
                // Violation warning
                if gameState.sessionViolated {
                    ViolationWarningView()
                }
            }
            .padding(30)
            
            // Hidden easter egg button - bottom left corner
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        easterEggTapCount += 1
                        if easterEggTapCount >= 3 {
                            showEasterEgg = true
                            easterEggTapCount = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            easterEggTapCount = 0
                        }
                    }) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
            }
            .padding(10)
            
            // Hamburger menu overlay
            if showHamburgerMenu {
                HamburgerMenuView(
                    isPresented: $showHamburgerMenu,
                    showShop: $showShop,
                    showCredits: $showCredits,
                    showAchievements: $showAchievements,
                    showSettings: $showSettings
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: showHamburgerMenu)
                        }
            // Shop overlay
            if showShop {
                ShopView(isPresented: $showShop)
            }
            // Credits overlay
            if showCredits {
                Credits(isPresented: $showCredits)
            }
            // Achievements overlay
            if showAchievements {
                AchievementView(isPresented: $showAchievements)
            }
            // Settings overlay
            if showSettings {
                SettingsView(isPresented: $showSettings)
            }
            // Easter egg overlay
            if showEasterEgg {
                EasterEgg(isPresented: $showEasterEgg)
            }
            // Achievement notification toast - appears at top
            if achievementManager.showNotification, let achievement = achievementManager.recentlyUnlocked {
                VStack {
                    AchievementNotification(achievement: achievement)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: achievementManager.showNotification)
                        .padding(.top, 20)
                            
                    Spacer()
                        }
                    }
        }
        .frame(width: 500, height: 700)
        .onChange(of: showEasterEgg) { isShown in
            if isShown {
                achievementManager.unlockEasterEgg(gameState: gameState)
            }
        }
    }
}

struct TopBarView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var showHamburgerMenu: Bool
    @Binding var showSettings: Bool
    @Binding var showShop: Bool
    @Binding var showCredits: Bool
    @Binding var showAchievements: Bool
    
    private var chromeBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(colorScheme == .dark ? Color.white.opacity(0.12) : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.18) : Color.black.opacity(0.2), lineWidth: 1)
            )
    }
    
    var body: some View {
        HStack {
            // Hamburger menu button (top left)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showHamburgerMenu = true
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(chromeBackground)
            }
            .buttonStyle(.plain)
            .disabled(gameState.isTimerRunning)
            
            Spacer()
            
            // Title and stats
            VStack {
                Text("Focus Island")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Level \(gameState.islandLevel) • 👥 \(gameState.population)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Right side buttons
            HStack(spacing: 12) {
                // Money display
                HStack(spacing: 4) {
                    Text("$\(gameState.money)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    // Pending earnings
                    if gameState.isTimerRunning && gameState.pendingEarnings > 0 {
                        Text("+\(gameState.pendingEarnings)")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(chromeBackground)
                
                // Settings button
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(chromeBackground)
                }
                .buttonStyle(.plain)
                .disabled(gameState.isTimerRunning)
            }
        }
    }
}



struct IslandView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        ZStack {
            // Island base
            Ellipse()
                .fill(Color.green.opacity(0.6))
                .frame(width: 350, height: 200)
                .shadow(radius: 10)
            
            // Displaying completed buildings
            if gameState.completedBuildings.isEmpty {
                Text("🏝️")
                    .font(.system(size: 75))
                Text("You are stranded on an empty island!\nGet to work and start building!")
                    //.font(.caption)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .offset(y: 60)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 5) {
                    ForEach(gameState.completedBuildings) { building in
                        Text(building.type.emoji)
                            .font(.title)
                    }
                }
                .frame(width: 250)
            }
        }
    }
}

struct TimerControlView: View {
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            if gameState.isTimerRunning {
                // Active timer display
                Text(timeString(from: gameState.remainingSeconds))
                    .font(.system(size: 60, weight: .thin, design: .monospaced))
                
                // Progress bar
                ProgressView(value: gameState.currentSessionProgress)
                    .progressViewStyle(.linear)
                    .frame(width: 300)
                
                // Earnings preview
                HStack {
                    Text("Earning:")
                    Text("$\(gameState.selectedSeconds)")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .font(.headline)
                
                Text("⚠️ Don't leave the app or you lose your earnings!")
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Button("Give Up") {
                    gameState.stopTimer()
                    NotificationManager.shared.cancelTimerNotifications()
                    SoundFeedbackManager.shared.play(event: .timerCancelled)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                
            } else {
                // Timer setup
                Text("Set Focus Duration")
                    .font(.headline)
                
                HStack {
                    Slider(value: Binding(
                        get: { Double(gameState.selectedSeconds) },
                        set: { gameState.selectedSeconds = Int($0) }
                    ), in: 1...120, step: 1)
                    .frame(width: 200)
                    
                    Text("\(gameState.selectedSeconds) sec")
                        .frame(width: 60)
                        .font(.title3)
                }
                
                // Showing potential earnings
                //Text("Complete to earn: $\(gameState.selectedSeconds)")
                //  .font(.subheadline)
                //.foregroundColor(.green)
                
                // Showing potential earnings and unlocked buildings
                EarningsPreviewView(seconds: gameState.selectedSeconds, buildingCosts: gameState.buildingCosts)
                              
                Button("Start Focus Session") {
                    gameState.startTimer()
                    NotificationManager.shared.scheduleTimerFinishedNotification(
                        after: TimeInterval(gameState.selectedSeconds),
                        enabled: settingsManager.notificationsEnabled
                    )
                    SoundFeedbackManager.shared.play(event: .timerStarted)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
        .background(
            colorScheme == .dark ? Color.black.opacity(0.32) : Color.white,
            in: RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.18) : Color.black.opacity(0.2), lineWidth: 1)
        )
    }
    
    func timeString(from seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
struct EarningsPreviewView: View {
    let seconds: Int
    let buildingCosts: [BuildingType: Int]
    
    // Getting all buildings affordable with current timer setting
    var affordableBuildings: [BuildingType] {
        BuildingType.allCases.filter { type in
            (buildingCosts[type] ?? 0) <= seconds
        }
    }
    
    // Finding the next building to unlock
    var nextUnlock: (building: BuildingType, secondsNeeded: Int)? {
        let locked = BuildingType.allCases
            .filter { (buildingCosts[$0] ?? 0) > seconds }
            .sorted { (buildingCosts[$0] ?? 0) < (buildingCosts[$1] ?? 0) }
        
        if let next = locked.first, let cost = buildingCosts[next] {
            return (next, cost - seconds)
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Money earnings
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
                Text("Earn: $\(seconds)")
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            .font(.subheadline)
            
            // Unlocked buildings display
            if affordableBuildings.isEmpty {
                Text("No buildings unlocked yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 6) {
                    Text("Buildings you can afford:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(affordableBuildings, id: \.self) { building in
                            VStack(spacing: 2) {
                                Text(building.emoji)
                                    .font(.title2)
                                Text("$\(buildingCosts[building] ?? 0)")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }
                            .padding(6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Hint for next unlock
            if let next = nextUnlock {
                HStack(spacing: 4) {
                    Text("Add \(next.secondsNeeded) sec to unlock")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text(next.building.emoji)
                    Text(next.building.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
struct ViolationWarningView: View {
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text("Session interrupted! Earnings lost.")
                .font(.caption)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
}
