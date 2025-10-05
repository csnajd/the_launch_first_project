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
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
        
        
        VStack {
            Text("انتهت الجولة")
                .font(.MainText)
                .foregroundColor(.black)
                .padding(.top, 60)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Button(action: {
                timerManager.reset()
                navigationPath.append("RoleView")
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

            
            Button(action: {
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
        .padding(.bottom, 40)
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
            navigationPath: .constant(NavigationPath())
        )
    }
}
