//
//  TimerManager.swift
//  the_launch_first_project
//
//  Created by Code Assistant on 02/10/2025.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    // MARK: - Configuration
    private let minTime: Double = 30
    private let maxTime: Double = 180
    
    // MARK: - Published State
    
    @Published var selectedTime: Double = 120 {
        didSet {
            let clamped = min(max(selectedTime, minTime), maxTime)
            if clamped != selectedTime {
                selectedTime = clamped
            }
        }
    }
    @Published var timeRemaining: Double = 0
    @Published var totalTime: Double = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var alarmPlaying: Bool = false
    @Published var shouldNavigateToEndGame: Bool = false

    private var timer: Timer?
    private var alarmSound = AlarmSound()
        
    init() {
        alarmSound.onAlarmFinished = { [weak self] in
            DispatchQueue.main.async {
                self?.alarmPlaying = false
                self?.shouldNavigateToEndGame = true
            }
        }
    }
    
    
    func start() {
        let clamped = min(max(selectedTime, minTime), maxTime)
        selectedTime = clamped
        totalTime = clamped
        timeRemaining = clamped
        isRunning = true
        isPaused = false
        alarmPlaying = false
        shouldNavigateToEndGame = false
        startTimer()
    }
    
    
    func togglePause() {
        isRunning.toggle()
        if isRunning {
            startTimer()
        } else {
            timer?.invalidate()
            isPaused = true
        }
    }
    
    
    func reset() {
        timer?.invalidate()
        isRunning = false
        isPaused = false
        timeRemaining = 0
        totalTime = 0
        alarmPlaying = false
        shouldNavigateToEndGame = false
        alarmSound.stopAlarm()
    }
    
    
    func adjustTime(by seconds: Double) {
        let newRemaining = min(max(timeRemaining + seconds, minTime), maxTime)
        timeRemaining = newRemaining
        totalTime = min(maxTime, max(totalTime, newRemaining))
    }
    
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timerCompleted()
            }
        }
    }
    
    
    private func timerCompleted() {
        timer?.invalidate()
        isRunning = false
        alarmPlaying = true
        alarmSound.playAlarm(for: 7.0)
    }
    
    
    
    func stopAlarm() {
        alarmSound.stopAlarm()
        alarmPlaying = false
        shouldNavigateToEndGame = true
    }

    /// Ends the current round early and navigates to the end-game screen.
    func endRoundEarly() {
        timer?.invalidate()
        isRunning = false
        isPaused = false
        alarmPlaying = false
        shouldNavigateToEndGame = true
    }
}


