//
//  TimerManager.swift
//  the_launch_first_project
//
//  Created by Code Assistant on 02/10/2025.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    @Published var selectedTime: Double = 132 // 2m 12s default
    @Published var timeRemaining: Double = 0
    @Published var totalTime: Double = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var timerEnded: Bool = false
    @Published var alarmPlaying: Bool = false
    @Published var shouldNavigateToEndGame: Bool = false

    private var timer: Timer?
    private var alarmSound = AlarmSound()
    
    var progressPercentage: Int {
        guard totalTime > 0 else { return 0 }
        return Int((1 - timeRemaining / totalTime) * 100)
    }
    
    
    init() {
        alarmSound.onAlarmFinished = { [weak self] in
            DispatchQueue.main.async {
                self?.alarmPlaying = false
                self?.shouldNavigateToEndGame = true
            }
        }
    }
    
    
    func start() {
         totalTime = selectedTime
         timeRemaining = selectedTime
         isRunning = true
         isPaused = false
         timerEnded = false
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
              timerEnded = false
              alarmPlaying = false
              shouldNavigateToEndGame = false
              alarmSound.stopAlarm()
    }
    
    
    func adjustTime(by seconds: Double) {
        timeRemaining = max(0, min(totalTime + 60, timeRemaining + seconds))
        totalTime = max(totalTime, timeRemaining)
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
        timerEnded = true
        alarmPlaying = true
        
        alarmSound.onAlarmFinished = { [weak self] in
            DispatchQueue.main.async {
                self?.alarmPlaying = false
                self?.shouldNavigateToEndGame = true
                print(" Alarm finished - shouldNavigateToEndGame = true")
            }
        }
        
        alarmSound.playAlarm(for: 7.0)
    }
    
    
    
    func stopAlarm() {
        alarmSound.stopAlarm()
        alarmPlaying = false
        shouldNavigateToEndGame = true
    }
}

 
