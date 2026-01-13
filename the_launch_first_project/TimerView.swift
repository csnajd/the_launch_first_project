//
//  TimerView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerManager: TimerManager
    @Binding var navigationPath: NavigationPath
    let playerNames: [String]
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 100)
                
                VStack(spacing: 24) {
                    if timerManager.alarmPlaying {
                        VStack {
                            Spacer().frame(height: 0)
                            
                            Text("انتهى الوقت!")
                                .font(.MainText).font(.system(.title, design: .rounded))
                                .foregroundColor(.ppurple)
                            
                            Spacer()
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.yyellow)
                            
                            Spacer()
                        }
                    } else if timerManager.isRunning || timerManager.isPaused {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            AnimatedClockView(
                                timeRemaining: timerManager.timeRemaining,
                                totalTime: timerManager.totalTime,
                                isRunning: timerManager.isRunning
                            )
                            
                            Spacer()
                        }
                    } else {
                        VStack {
                            VStack(spacing: 8) {
                                Text("وقت اللعب !!")
                                    .font(.MainText).font(.system(.title, design: .rounded))
                                
                                Text("اضغط يلا عشان يبدأ المؤقت")
                                    .font(.PlayerText)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                            
                            Image("Clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 220)
                            
                            Spacer()
                            
                            TimePickerView(selectedTime: $timerManager.selectedTime)
                                .frame(height: 100)
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                if timerManager.alarmPlaying {
                    
                    Button {
                        timerManager.stopAlarm()
                    } label: {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 60)
                            Text("إيقاف الصوت")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 60)
                } else if timerManager.isRunning || timerManager.isPaused {
                    HStack(spacing: 20) {
                        Button("-30s") { timerManager.adjustTime(by: -30) }
                            .font(.title2).bold().foregroundColor(.ppurple).contentShape(Rectangle())
                        
                        Button {
                            timerManager.togglePause()
                        } label: {
                            ZStack {
                                Image("yellowC")
                                    .resizable()
                                    .frame(width: 65, height: 65)
                                Image(systemName: timerManager.isRunning ? "pause.fill" : "play.fill")
                                    .foregroundColor(.background)
                                    .font(.title)
                            }
                        }
                        
                        Button {
                            timerManager.reset()
                        } label: {
                            ZStack {
                                Image("yellowC")
                                    .resizable()
                                    .frame(width: 65, height: 65)
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.background)
                                    .font(.title2).bold()
                            }
                        }
                        
                        Button("+30s") { timerManager.adjustTime(by: 30) }
                            .font(.title2).bold().foregroundColor(.ppurple)
                    }
                    .padding(.bottom, 60)
                } else {
                    Button {
                        timerManager.start()
                    } label: {
                        ZStack {
                            Image("purpleBS")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 277, height: 55)
                            Text("يلا")
                                .font(.MainText)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
        .withHomeButton(navigationPath: $navigationPath)
        .onChange(of: timerManager.shouldNavigateToEndGame) { _, newValue in
            if newValue {
                navigationPath.append(EndGameViewData(playerNames: playerNames))
            }
        }
    }
}


struct TimePickerView: View {
    @Binding var selectedTime: Double
    var body: some View {
        HStack {
            Picker("Minutes", selection: Binding(
                get: { Int(selectedTime) / 60 },
                set: { selectedTime = Double($0 * 60 + (Int(selectedTime) % 60)) }
            )) {
                ForEach(0...3, id: \.self) { Text("\($0) د").tag($0) }
            }
            .pickerStyle(.wheel)
            
            Picker("Seconds", selection: Binding(
                get: { Int(selectedTime) % 60 },
                set: { selectedTime = Double((Int(selectedTime) / 60) * 60 + $0) }
            )) {
                ForEach(0...59, id: \.self) { Text(String(format: "%02d ث", $0)).tag($0) }
            }
            .pickerStyle(.wheel)
        }
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
         ZStack {
                Image("timer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .offset(y: -150)
                }
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.yyellow, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.3), value: progress)
            
            Circle()
                .stroke(Color.ppurple, lineWidth: 13)
                .frame(width: 280, height: 280)
            
            Text(String(format: "%d:%02d", Int(timeRemaining) / 60, Int(timeRemaining) % 60))
                .font(.system(size: 52, weight: .bold))
                .foregroundColor(progress > 0.9 ? .red : .ppurple)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var path = NavigationPath()
        @StateObject private var timerManager = TimerManager()
        
        var body: some View {
            NavigationStack(path: $path) {
                TimerView(
                    timerManager: timerManager,
                    navigationPath: $path,
                    playerNames: ["أحمد", "سارة", "منى"]
                )
            }
            .onAppear {
                timerManager.isRunning = true
                timerManager.timeRemaining = 120
            }
        }
    }
    return PreviewWrapper()
}
