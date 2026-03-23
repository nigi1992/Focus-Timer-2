//
//  AchievementNotification.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//


// Achievement notification toast - Quick popup when achievement unlocks

import SwiftUI

struct AchievementNotification: View {
    @Environment(\.colorScheme) private var colorScheme
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 15) {
            // Achievement icon with animation
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Text(achievement.emoji)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Achievement Unlocked!")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                Text(achievement.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    Text("+$\(achievement.reward)")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .font(.caption)
            }
            
            Spacer()
            
            Image(systemName: "trophy.fill")
                .font(.title)
                .foregroundColor(.yellow)
        }
        .padding()
        .frame(width: 320)
        .background(
            colorScheme == .dark ? Color.black.opacity(0.4) : Color.white,
            in: RoundedRectangle(cornerRadius: 16)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
        )
    }
}
