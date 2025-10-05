//
//  TimerView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var playerManager: PlayerManager  
    @StateObject private var timerManager = TimerManager()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            NavigationStack(path: $navigationPath) {
                VStack(spacing: 40) {
                    
                    // Game over !
                    
                    if timerManager.alarmPlaying {
                        
                        VStack(spacing: 30) {
                            
                            HStack {
                                Image(systemName:"exclamationmark")
                                    .font(.MainText)
                                    .foregroundColor(.ppurple)
                                
                                Text("خلص الوقت ")
                                    .multilineTextAlignment(.center)
                                    .font(.MainText)
                                    .foregroundColor(.ppurple)
                                
                                
                            }
                            Image(systemName: "bell.fill")
                                .font(.PlayerNameText)
                                .foregroundColor(.yyellow)
                            
                        }
                        .padding()
                        
                        
                    } else if timerManager.isRunning || timerManager.isPaused {
                        
                        // Running Timer View
                        AnimatedClockView(
                            timeRemaining: timerManager.timeRemaining,
                            totalTime: timerManager.totalTime,
                            isRunning: timerManager.isRunning
                        )
                        
                        
                        
                        // Control Buttons
                        HStack(spacing: 20) {
                            Button(action: {
                                timerManager.adjustTime(by: -30)
                            }) {
                                Text("-")
                                    .font(.system(size: 40))
                                    .foregroundColor(.ppurple)
                            }
                            
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
                            
                            Button(action: {
                                timerManager.adjustTime(by: 30)
                            }) {
                                Text("+")
                                    .font(.system(size: 30))
                                    .foregroundColor(.ppurple)
                            }
                        }
                        .padding(.bottom, 40)
                        
                        
                        
                        
                        // Time to play !!
                        
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
                                        .scaledToFit()
                                        .frame(width: 277, height: 55)
                                    
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
                .onChange(of: timerManager.shouldNavigateToEndGame) {
                    if timerManager.shouldNavigateToEndGame {
                        navigationPath.append("EndGameView")
                    }
                }
                .navigationDestination(for: String.self) { destination in
                    if destination == "EndGameView" {
                        EndGameView(timerManager: timerManager, navigationPath: $navigationPath)
                    } else if destination == "RoleView" {
                        RoleView(playerNames: ["لاعب ١", "لاعب ٢", "لاعب ٣", "لاعب ٤"], navigationPath: $navigationPath)
                    } else if destination == "AddPlayerView" {
                        AddPlayerView(navigationPath: $navigationPath)  // عدل هذا
                    } else if destination == "TimerView" {
                        TimerView()
                    } else if destination == "RoleViewWithNames" {
                      
                    }
                }
                
            }
        }
    }
    
    
    
    
    
    // ..
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
    
    
    
    //PresetButtonViwe
    
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
                        .foregroundColor(isSelected ? .ppurple : .gray)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    
    
    //AnimatedClockViwe
    
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
                    .position(x: 202, y: 118)
                
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
                return Color.ppurple
            }
        }
        
        private func formatTime(_ seconds: Double) -> String {
            let mins = Int(seconds) / 60
            let secs = Int(seconds) % 60
            return String(format: "%d:%02d", mins, secs)
        }
    }
    
    
    //ClockMarkerViwe
    
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
    
    
}
    struct TimerView_Previews: PreviewProvider {
        static var previews: some View {
            TimerView()
        }
    }
