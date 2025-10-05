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
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // عرض عند انتهاء الوقت
                if timerManager.alarmPlaying {
                    VStack(spacing: 30) {
                        HStack {
                            Image(systemName:"exclamationmark")
                                .font(.title)
                                .foregroundColor(.purple)
                            Text("خلص الوقت")
                                .font(.title)
                                .foregroundColor(.purple)
                        }
                        Image(systemName: "bell.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                    }
                    .padding()
                    
                // عرض المؤقت أثناء التشغيل أو التوقف المؤقت
                } else if timerManager.isRunning || timerManager.isPaused {
                    AnimatedClockView(
                        timeRemaining: timerManager.timeRemaining,
                        totalTime: timerManager.totalTime,
                        isRunning: timerManager.isRunning
                    )
                    
                    HStack(spacing: 20) {
                        Button(action: { timerManager.adjustTime(by: -30) }) {
                            Text("-")
                                .font(.system(size: 40))
                                .foregroundColor(.purple)
                        }
                        Button(action: { timerManager.togglePause() }) {
                            ZStack {
                                Image("yellowC")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                Image(systemName: timerManager.isRunning ? "pause.fill" : "play.fill")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        Button(action: { timerManager.reset() }) {
                            ZStack {
                                Image("yellowC")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                Image(systemName: "arrow.clockwise")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        Button(action: { timerManager.adjustTime(by: 30) }) {
                            Text("+")
                                .font(.system(size: 30))
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.bottom, 40)
                    
                // عرض عند الإعداد قبل البدء
                } else {
                    VStack(spacing: 30) {
                        Text("وقت اللعب !!")
                            .font(.title)
                        Text("اضغط يلا عشان يبدا المؤقت\n(يمديك تختار الوقت بس اكثر شي ٣ دقايق)")
                            .multilineTextAlignment(.center)
                        
                        Image("Clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        TimePresetsView(selectedTime: $timerManager.selectedTime)
                        
                        Button(action: { timerManager.start() }) {
                            ZStack {
                                Image("purpleBS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 277, height: 55)
                                Text("يلا")
                                    .foregroundColor(.white)
                                    .font(.title2)
                            }
                        }
                    }
                }
            }
            .padding(.top, 100)
        }
    }
}

// عرض أزرار اختيار الوقت
struct TimePresetsView: View {
    @Binding var selectedTime: Double
    let presets: [(time: Double, label: String)] = [
        (30, "30s"), (60, "1m"), (90, "1.5m"), (120, "2m"), (150, "2.5m"), (180, "3m")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("اختر الوقت")
                .font(.title3)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(presets, id: \.time) { preset in
                    Button(action: { selectedTime = preset.time }) {
                        Text(preset.label)
                            .fontWeight(.bold)
                            .foregroundColor(selectedTime == preset.time ? .purple : .gray)
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

// عرض المؤقت بشكل دائري
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
            Image("timer")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.yellow, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.3), value: progress)
            
            Circle()
                .stroke(Color.purple, lineWidth: 13)
                .frame(width: 280, height: 280)
            
            Text(formatTime(timeRemaining))
                .font(.system(size: 52, weight: .bold))
                .foregroundColor(timeColor)
        }
    }
    
    var timeColor: Color {
        let percentage = (timeRemaining / totalTime) * 100
        return percentage <= 10 ? .red : .purple
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

#if DEBUG
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
#endif
