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
                    AnimatedClockView(
                        timeRemaining: timerManager.timeRemaining,
                        totalTime: timerManager.totalTime,
                        isRunning: timerManager.isRunning
                    )
                    
                    HStack(spacing: 20) {
                        Button(action: { timerManager.adjustTime(by: -30) }) {
                            Text("-")
                                .font(.system(size: 40))
                                .foregroundColor(.ppurple)
                        }
                        
                        Button(action: { timerManager.togglePause() }) {
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
                        
                        Button(action: { timerManager.reset() }) {
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
                        
                        Button(action: { timerManager.adjustTime(by: 30) }) {
                            Text("+")
                                .font(.system(size: 30))
                                .foregroundColor(.ppurple)
                        }
                    }
                    .padding(.bottom, 40)
                    
                } else {
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
                        
                        TimePresetsView(selectedTime: $timerManager.selectedTime)
                        
                        Button(action: { timerManager.start() }) {
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
        }
    }
}

#if DEBUG
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
#endif
