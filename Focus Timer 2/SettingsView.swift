//
//  SettingsManager.swift
//  Focus Timer 2
//
//  Created by Nicolas Waser on 31.01.2026.
//


// Settings View - App configuration and preferences

import SwiftUI
import Combine

class SettingsManager: ObservableObject {
    @Published var soundEnabled: Bool = true
    @Published var notificationsEnabled: Bool = true
    @Published var darkModeEnabled: Bool = false
    @Published var autoStartBreak: Bool = false
    @Published var showPendingEarnings: Bool = true
    @Published var defaultTimerMinutes: Int = 25
    @Published var hapticFeedbackEnabled: Bool = true
}

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.colorScheme) private var colorScheme
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
                    Text("⚙️ Settings")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                
                Divider()
                
                // Scrollable settings content
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 20) {
                        
                        // Timer Settings
                        SettingsSection(title: "Timer", icon: "timer") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Default Duration")
                                    Spacer()
                                    Picker("", selection: $settingsManager.defaultTimerMinutes) {
                                        Text("15 min").tag(15)
                                        Text("25 min").tag(25)
                                        Text("45 min").tag(45)
                                        Text("60 min").tag(60)
                                    }
                                    .frame(width: 120)
                                }
                                
                                Toggle("Auto-start break after session", isOn: $settingsManager.autoStartBreak)
                            }
                        }
                        
                        // Display Settings
                        SettingsSection(title: "Display", icon: "eye") {
                            VStack(alignment: .leading, spacing: 12) {
                                Toggle("Show pending earnings", isOn: $settingsManager.showPendingEarnings)
                                Toggle("Dark mode", isOn: $settingsManager.darkModeEnabled)
                            }
                        }
                        
                        // Sound & Feedback Settings
                        SettingsSection(title: "Sound & Feedback", icon: "speaker.wave.2") {
                            VStack(alignment: .leading, spacing: 12) {
                                Toggle("Sound effects", isOn: $settingsManager.soundEnabled)
                                Toggle("Haptic feedback", isOn: $settingsManager.hapticFeedbackEnabled)
                                Toggle("Notifications", isOn: $settingsManager.notificationsEnabled)
                            }
                        }
                        
                        // About Section
                        SettingsSection(title: "About", icon: "info.circle") {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Version")
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Text("Build")
                                    Spacer()
                                    Text("2026.01.31")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        // Reset Section
                        SettingsSection(title: "Data", icon: "arrow.counterclockwise") {
                            Button(action: {
                                // Resetting to defaults
                                settingsManager.soundEnabled = true
                                settingsManager.notificationsEnabled = true
                                settingsManager.darkModeEnabled = false
                                settingsManager.autoStartBreak = false
                                settingsManager.showPendingEarnings = true
                                settingsManager.defaultTimerMinutes = 25
                                settingsManager.hapticFeedbackEnabled = true
                            }) {
                                Text("Reset Settings to Default")
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxHeight: 380)
            }
            .padding(30)
            .frame(width: 420, height: 520)
            .background(
                colorScheme == .dark ? Color.black.opacity(0.35) : Color.white,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.18) : Color.black.opacity(0.2), lineWidth: 1)
            )
            .shadow(radius: 20)
        }
    }
}

struct SettingsSection<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
            }
            
            // Section content
            content
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06),
                    in: RoundedRectangle(cornerRadius: 12)
                )
        }
    }
}
