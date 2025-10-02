//
//  TimerView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var timerManager = TimerManager()
    
    var body: some View {
        VStack(spacing: 40) {
            
            if timerManager.isRunning || timerManager.isPaused {
                // Running Timer View
                AnimatedClockView(
                    timeRemaining: timerManager.timeRemaining,
                    totalTime: timerManager.totalTime,
                    isRunning: timerManager.isRunning
                )
                
                                
                
                // Control Buttons
                HStack(spacing: 20) {
                    
                    // Minus action (unchanged)
                    Button(action: {
                        timerManager.adjustTime(by: -30)
                    }) {
                        Text("-")
                            .font(.system(size: 40))
                            .foregroundColor(.ppurple)
                    }

                    // Play/Pause button
                    Button(action: {
                        timerManager.togglePause()
                    }) {
                        ZStack {
                            Image("yellowC")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: timerManager.isRunning ? "pause.fill" : "play.fill")
                                .font(.PlayerText)
                                .bold()
                                .foregroundColor(.background)
                                .frame(width: 55, height: 55)
                        }
                        
                       
                    }

                    // Reset button with your custom image
                    Button(action: {
                        timerManager.reset()
                    }) {
                        ZStack {
                            Image("yellowC")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "arrow.clockwise")
                                .font(.PlayerText)
                                .bold()
                                .foregroundColor(.background)
                                .frame(width: 55, height: 55)
                        }
                    }

                    // Plus action (unchanged)
                    Button(action: {
                        timerManager.adjustTime(by: 30)
                    }) {
                        Text("+")
                            .font(.system(size: 30))
                            .foregroundColor(.ppurple)
                    }
                }
                .padding(.bottom, 40)
                
                
        
            } else {
                // Setup View
                VStack {
                    Text("وقت اللعب !!")
                        .font(.MainText)
                        .padding(.bottom)
                    Text("اضغط يلا عشان يبدا المؤقت\n(يمديك تختار الوقت بس اكثر شي ٣ دقايق)")
                        .multilineTextAlignment(.center)
                        .font(.PlayerText)
                        .padding(.bottom)

                    
                    Image("Clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 40)
                    
                }
                
                VStack(spacing: 30) {
                    TimePresetsView(selectedTime: $timerManager.selectedTime)
                    
                    Button(action: {
                        timerManager.start()
                    }) {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .frame(width: 277, height: 55)
                                .cornerRadius(10)
                            
                            Text("يلا")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .padding(.top, 100)
    }
}






struct TimePresetsView: View {
    @Binding var selectedTime: Double
    
    let presets: [(time: Double, label: String)] = [
        (30, "30s"),
        (60, "1m"),
        (90, "1.5m"),
        (120, "2m"),
        (150, "2.5m"),
        (180, "3m")
    ]
    
    
    //Choose the min
    
    var body: some View {
        VStack(spacing: 20) {
            Text("اختر الوقت")
                .font(.PlayerText)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 15),
                GridItem(.flexible(), spacing: 15),
                GridItem(.flexible(), spacing: 15)
            ], spacing: 15) {
                ForEach(presets, id: \.time) { preset in
                    PresetButton(
                        time: preset.time,
                        label: preset.label,
                        isSelected: selectedTime == preset.time,
                        action: {
                            selectedTime = preset.time
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 30)
    }
}


struct PresetButton: View {
    let time: Double
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(label)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isSelected ? Color(hex: "9333EA") : .gray)
            }
        }
        .buttonStyle(.plain)
    }
}



struct AnimatedClockView: View {
    let timeRemaining: Double
    let totalTime: Double
    let isRunning: Bool
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1 - (timeRemaining / totalTime)
    }
    
    var body: some View {
        ZStack {
            
            Image ("timer")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .position(x: 206.5, y: 125.5)
            
            // Progress arc
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                .yyellow,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .frame(width: 260, height: 260)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.3), value: progress)
                        
            // Outer circles
            Circle()
                .stroke(Color.ppurple, lineWidth: 13)
                .frame(width: 280, height: 280)
                  
            
            // Clock markers
                        ForEach(0..<4) { index in
                            ClockMarker(index: index)
                        }
                        
            
            // Time display
            Text(formatTime(timeRemaining))
                .font(.system(size: 52, weight: .bold))
                .foregroundColor(timeColor)
        }
    }
    
    var timeColor: Color {
        let percentage = (timeRemaining / totalTime) * 100
        if percentage <= 10 {
            return Color.red
        } else {
            return Color(.ppurple)
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

struct ClockMarker: View {
    let index: Int
    
    var body: some View {
        Rectangle()
            .fill(.ppurple)
            .frame(width: 8, height: 20)
            .cornerRadius(4)
            .offset(y: -140)
            .rotationEffect(.degrees(Double(index) * 90))
    }
}


class TimerManager: ObservableObject {
    @Published var selectedTime: Double = 132 // 2m 12s default
    @Published var timeRemaining: Double = 0
    @Published var totalTime: Double = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
    
    var progressPercentage: Int {
        guard totalTime > 0 else { return 0 }
        return Int((1 - timeRemaining / totalTime) * 100)
    }
    
    func start() {
        totalTime = selectedTime
        timeRemaining = selectedTime
        isRunning = true
        isPaused = false
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
        // You can add sound or vibration here
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    TimerView()
}

