//
//  AchievementView.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//


// Achievement View - Displaying all achievements and progress

import SwiftUI

struct AchievementView: View {
    @EnvironmentObject var achievementManager: AchievementManager
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("🏆 Achievements")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Spacer()
                    
                    let progress = achievementManager.progress()
                    Text("\(progress.unlocked)/\(progress.total)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                // Scrollable achievements list
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 12) {
                        ForEach(Achievement.allCases) { achievement in
                            AchievementRow(
                                achievement: achievement,
                                isUnlocked: achievementManager.unlockedAchievements.contains(achievement)
                            )
                        }
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxHeight: 400)
            }
            .padding(30)
            .frame(width: 450, height: 550)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Achievement icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(achievement.emoji)
                    .font(.title2)
                    .grayscale(isUnlocked ? 0 : 1)
                    .opacity(isUnlocked ? 1 : 0.5)
            }
            
            // Achievement details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(achievement.rawValue)
                        .font(.headline)
                        //.foregroundColor(isUnlocked ? .primary : .secondary)
                        .foregroundColor(isUnlocked ? .black : .gray)
                    
                    if isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
                
                Text(achievement.description)
                    .font(.caption)
                    //.foregroundColor(.secondary)
                    .foregroundColor(isUnlocked ? .black : .gray)
                // Reward display
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .font(.caption2)
                    Text("+$\(achievement.reward) reward")
                        .font(.caption2)
                }
                .foregroundColor(isUnlocked ? .green : .gray)
            }
            
            Spacer()
            
            // Lock icon for locked achievements
            if !isUnlocked {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(isUnlocked ? Color.yellow.opacity(0.1) : Color.gray.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}
