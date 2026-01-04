//
//  AlarmSound.swift
//  the_launch_first_project
//
//  Created by yumii on 02/10/2025.
//

import Foundation
import AVFoundation

class AlarmSound: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var stopTimer: Timer?
    var onAlarmFinished: (() -> Void)?
    @Published var isPlaying = false 
    func playAlarm(for duration: TimeInterval = 30.0) {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            print("Unable to find alarm.mp3")
            onAlarmFinished?()
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
            

            stopTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
                self?.stopAlarm()
                self?.onAlarmFinished?()
            }
            
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
            onAlarmFinished?()
        }
    }
    
    func stopAlarm() {
        audioPlayer?.stop()
        stopTimer?.invalidate()
        stopTimer = nil
    }
}
