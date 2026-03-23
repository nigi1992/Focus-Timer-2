//
//  HamburgerMenuView.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//


// Hamburger Menu - Side navigation menu

import SwiftUI

struct HamburgerMenuView: View {
    @Binding var isPresented: Bool
    @Binding var showShop: Bool
    @Binding var showCredits: Bool
    @Binding var showAchievements: Bool
    @Binding var showSettings: Bool
    @EnvironmentObject var gameState: GameState
    @EnvironmentObject var achievementManager: AchievementManager
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPresented = false
                    }
                }
            
            HStack {
                // Menu panel
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🏝️ Focus Island")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Level \(gameState.islandLevel)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    
                    Divider()
                    
                    // Menu items
                    ScrollView {
                        VStack(spacing: 0) {
                            MenuRow(icon: "cart.fill", title: "Shop", color: .green) {
                                closeAndOpen { showShop = true }
                            }
                            
                            MenuRow(icon: "trophy.fill", title: "Achievements", badge: "\(achievementManager.progress().unlocked)/\(achievementManager.progress().total)", color: .orange) {
                                closeAndOpen { showAchievements = true }
                            }
                            
                            MenuRow(icon: "gearshape.fill", title: "Settings", color: .gray) {
                                closeAndOpen { showSettings = true }
                            }
                            
                            Divider()
                                .padding(.vertical, 10)
                            
                            MenuRow(icon: "info.circle.fill", title: "Credits", color: .blue) {
                                closeAndOpen { showCredits = true }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Footer stats
                    VStack(alignment: .leading, spacing: 8) {
                        Divider()
                        
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundColor(.green)
                            Text("$\(gameState.money)")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        //$settingsManager.darkModeEnabled
                           // .foregroundColor(canAfford ? .green : .gray)
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("\(gameState.totalFocusSeconds) min focused")
                                .font(.caption)
                        }
                        
                        HStack {
                            Image(systemName: "building.2.fill")
                                .foregroundColor(.orange)
                            Text("\(gameState.completedBuildings.count) buildings")
                                .font(.caption)
                        }
                    }
                    .padding()
                    .foregroundColor(.secondary)
                    .background(Color.blue.opacity(0.1))
                }
                .frame(width: 250)
                .background(Color.white)
                //.background(Color.blue.opacity(0.1))
                .shadow(radius: 10)
                .transition(.move(edge: .leading))
                
                Spacer()
            }
        }
    }
    
    private func closeAndOpen(action: @escaping () -> Void) {
        withAnimation(.easeOut(duration: 0.2)) {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            action()
        }
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    var badge: String? = nil
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let badge = badge {
                    Text(badge)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(color.opacity(0.8))
                        .cornerRadius(10)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Color.white)
    }
}
