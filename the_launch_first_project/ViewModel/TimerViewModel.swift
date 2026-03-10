import Foundation
import SwiftUI
import UIKit

/// ViewModel responsible for timer screen side-effects such as haptics and
/// tracking transient UI-related state for `TimerView`.
final class TimerViewModel: ObservableObject {
    
    // MARK: - Published UI State
    
    /// Used to detect per-second changes and avoid repeated haptics.
    @Published var previousTimeRemaining: Double = 0
    
    /// Tracks whether the start-haptic has already been triggered for the current run.
    @Published var hasTriggeredStartHaptic: Bool = false
    
    // MARK: - Haptic Generators
    
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    // MARK: - Intent Handlers
    
    /// Handles changes to the running state of the timer and triggers start haptics.
    func handleRunningChanged(oldValue: Bool, newValue: Bool) {
        if newValue && !oldValue && !hasTriggeredStartHaptic {
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(.success)
            hasTriggeredStartHaptic = true
        } else if !newValue {
            hasTriggeredStartHaptic = false
        }
    }
    
    /// Handles countdown updates and triggers subtle haptics when close to zero.
    func handleTimeRemainingChanged(isRunning: Bool, oldValue: Double, newValue: Double) {
        if isRunning,
           newValue <= 5,
           newValue > 0,
           Int(oldValue) != Int(newValue) {
            selectionGenerator.prepare()
            selectionGenerator.selectionChanged()
        }
        
        previousTimeRemaining = newValue
    }
    
    /// Handles alarm state transitions and triggers error haptic and accessibility announcement.
    func handleAlarmPlayingChanged(oldValue: Bool, newValue: Bool) {
        guard newValue, !oldValue else { return }
        
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(.error)
        
        if UIAccessibility.isVoiceOverRunning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIAccessibility.post(notification: .announcement, argument: "انتهى الوقت")
            }
        }
    }
}

