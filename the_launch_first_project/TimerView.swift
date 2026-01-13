//
//  TimerView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI
import UIKit

private struct AccessibilityEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = UIAccessibility.isVoiceOverRunning
}

extension EnvironmentValues {
    var accessibilityEnabled: Bool {
        get { self[AccessibilityEnabledKey.self] }
        set { self[AccessibilityEnabledKey.self] = newValue }
    }
}

struct TimerView: View {
    @ObservedObject var timerManager: TimerManager
    @Binding var navigationPath: NavigationPath
    let playerNames: [String]
    @Environment(\.accessibilityEnabled) var isVoiceOverOn
    
    // Haptic
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    @State private var previousTimeRemaining: Double = 0
    @State private var hasTriggeredStartHaptic = false
    
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
                                .accessibilityLabel("انتهى الوقت")
                            
                            Spacer()
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.yyellow)
                                .accessibilityLabel("اِكْتَمَلَتِ الْجَوْلَة")
                            
                            Spacer()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("اِكْتَمَلَتِ الْجَوْلَة")
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
                                    .font(.MainText)
                                    .accessibilityLabel("وَقْتُ اللَّعِب")
                                
                                Text("اضغط يلا عشان يبدأ المؤقت")
                                    .font(.PlayerText)
                                    .multilineTextAlignment(.center)
                                    .accessibilityLabel("إِضْغَطْ يَلَّا عَشَانْ يِبْدَأ الْمُؤَقِّتْ")
                            }
                            
                            Spacer()
                            
                            Image("Clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 220)
                                .accessibilityLabel("صورة ساعة")
                            
                            Spacer()
                            
                            TimePickerView(selectedTime: $timerManager.selectedTime)
                                .frame(height: 100)
                                .accessibilityLabel("اختيار وقت الجولة")
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                if timerManager.alarmPlaying {
                    
                    Button {
                        impactGenerator.impactOccurred()
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
                        Button {
                            impactGenerator.impactOccurred()
                            timerManager.adjustTime(by: -30)
                        } label: {
                            Text("-30")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.ppurple)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("إِنْقَاصُ الْوَقْتِ ثَلَاثِينَ ثَانِيَة")
                        .accessibilityRemoveTraits(.isButton)
                        
                        Button {
                            impactGenerator.impactOccurred()
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
                    .accessibilityLabel(timerManager.isRunning ? "إيقاف مؤقت" : "تشغيل مؤقت")
                        
                        Button {
                            impactGenerator.impactOccurred()
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
                    .accessibilityLabel("إعادة ضبط المؤقت")
                        
                        Button {
                            impactGenerator.impactOccurred()
                            timerManager.adjustTime(by: 30)
                        } label: {
                            Text("+30")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.ppurple)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("زِيَادَةُ الْوَقْتِ ثَلَاثِينَ ثَانِيَة")
                        .accessibilityRemoveTraits(.isButton)
                    }
                    .padding(.bottom, 60)
                } else {
                    Button {
                        impactGenerator.impactOccurred()
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
                    .accessibilityLabel("بدء اللعبة")
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
        .onChange(of: timerManager.isRunning) { oldValue, newValue in
            if newValue && !oldValue && !hasTriggeredStartHaptic {
                notificationGenerator.prepare()
                notificationGenerator.notificationOccurred(.success)
                hasTriggeredStartHaptic = true
            } else if !newValue {
                hasTriggeredStartHaptic = false
            }
        }
        .onChange(of: timerManager.timeRemaining) { oldValue, newValue in
            if timerManager.isRunning && newValue <= 5 && newValue > 0 && Int(oldValue) != Int(newValue) {
                selectionGenerator.prepare()
                selectionGenerator.selectionChanged()
            }
            previousTimeRemaining = newValue
        }
        .onChange(of: timerManager.alarmPlaying) { oldValue, newValue in
            if newValue && !oldValue {
                notificationGenerator.prepare()
                notificationGenerator.notificationOccurred(.error)
                
                if UIAccessibility.isVoiceOverRunning {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        UIAccessibility.post(notification: .announcement, argument: "انتهى الوقت")
                    }
                }
            }
        }
    }
}


struct TimePickerView: View {
    @Binding var selectedTime: Double
    
    private var minutes: Int {
        Int(selectedTime) / 60
    }
    
    private var seconds: Int {
        Int(selectedTime) % 60
    }
    
    private var minutesBinding: Binding<Int> {
        Binding(
            get: { self.minutes },
            set: { newMinutes in
                selectedTime = Double(newMinutes * 60 + self.seconds)
            }
        )
    }
    
    private var secondsBinding: Binding<Int> {
        Binding(
            get: { self.seconds },
            set: { newSeconds in
                selectedTime = Double(self.minutes * 60 + newSeconds)
            }
        )
    }
    
    private var accessibilityTimeValue: String {
        if minutes > 0 && seconds > 0 {
            return "\(minutes) دَقِيقَة وَ \(seconds) ثَانِيَة"
        } else if minutes > 0 {
            return "\(minutes) دَقِيقَة"
        } else {
            return "\(seconds) ثَانِيَة"
        }
    }
    
    var body: some View {
        HStack {
            minutesPicker
            secondsPicker
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("مُدَّةُ الْجَوْلَة")
        .accessibilityValue(accessibilityTimeValue)
    }
    
    private var minutesPicker: some View {
        Picker("Minutes", selection: minutesBinding) {
            ForEach(0...3, id: \.self) { minute in
                Text("\(minute) د").tag(minute)
            }
        }
        .pickerStyle(.wheel)
    }
    
    private var secondsPicker: some View {
        Picker("Seconds", selection: secondsBinding) {
            ForEach(0...59, id: \.self) { second in
                Text(String(format: "%02d ث", second)).tag(second)
            }
        }
        .pickerStyle(.wheel)
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
                    .accessibilityHidden(true)
            }
            .accessibilityHidden(true)
            
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("المؤقت المتبقي")
        .accessibilityValue(Text(String(format: "%d دقائق و %02d ثواني", Int(timeRemaining) / 60, Int(timeRemaining) % 60)))
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
