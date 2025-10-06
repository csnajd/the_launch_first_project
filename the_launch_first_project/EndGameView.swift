//
//  EndGameView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct EndGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var timerManager: TimerManager
    @Binding var navigationPath: NavigationPath
    
    // نحتاج بيانات اللاعبين عشان نرجع للرول فيو
    let playerNames: [String]

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack {
                Text("انتهت الجولة")
                    .font(.MainText)
                    .foregroundColor(.black)
                    .padding(.top, 60)
                
                Spacer()

                // زر جولة ثانية - يودي لصفحة الرول
                Button(action: {
                    timerManager.reset()
                    navigationPath.removeLast(navigationPath.count)
                    // نرجع للرول فيو بنفس اللاعبين
                    let roleViewData = RoleViewData(playerNames: playerNames)
                    navigationPath.append(roleViewData)
                }) {
                    ZStack {
                        Image("blueB")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359, height: 60)
                        Text("كمل جولة ثانية")
                            .font(.PlayerText)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 5)

                // زر تغيير اللاعبين - يودي لصفحة الأد بلير
                Button(action: {
                    navigationPath.removeLast(navigationPath.count)
                    navigationPath.append("AddPlayerView")
                }) {
                    ZStack {
                        Image("purpleBL")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359, height: 59)
                        Text("تغيير اللاعبين")
                            .font(.PlayerText)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.bottom, 60)
            .padding(.horizontal, 8)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                timerManager.stopAlarm()
            }
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(
            timerManager: TimerManager(),
            navigationPath: .constant(NavigationPath()),
            playerNames: ["أحمد", "سارة", "منى", "خالد"] // أضيفي هذا
        )
    }
}
