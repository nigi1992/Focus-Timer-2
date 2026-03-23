//
//  SoundFeedbackManager.swift
//  Focus Timer 2
//
//  Created by Codex on 23.03.2026.
//

import Foundation

#if canImport(AppKit)
import AppKit
#endif

enum FeedbackEvent {
    case timerStarted
    case timerCompleted
    case timerCancelled
}

final class SoundFeedbackManager {
    static let shared = SoundFeedbackManager()

    private weak var settingsManager: SettingsManager?

    private init() {}

    func configure(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
    }

    func play(event: FeedbackEvent) {
        playSoundIfEnabled(for: event)
        playHapticIfEnabled()
    }

    func playCustomSound(named name: String) {
        guard settingsManager?.soundEnabled ?? true else { return }

        #if canImport(AppKit)
        if let sound = NSSound(named: NSSound.Name(name)) {
            sound.play()
        }
        #endif
    }

    private func playSoundIfEnabled(for event: FeedbackEvent) {
        guard settingsManager?.soundEnabled ?? true else { return }

        #if canImport(AppKit)
        let soundName: NSSound.Name
        switch event {
        case .timerStarted:
            soundName = .init("Pop")
        case .timerCompleted:
            soundName = .init("Hero")
        case .timerCancelled:
            soundName = .init("Basso")
        }

        if let sound = NSSound(named: soundName) {
            sound.play()
        } else {
            NSSound.beep()
        }
        #endif
    }

    private func playHapticIfEnabled() {
        guard settingsManager?.hapticFeedbackEnabled ?? true else { return }

        #if canImport(AppKit)
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        #endif
    }
}
