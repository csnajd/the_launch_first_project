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
    
    var body: some View {
        VStack {
            
            Text("انتهت الجولة")
                .font(.MainText)
                .foregroundColor(.black)
                .padding(.top, 60)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Button(action: {
                timerManager.reset()
                dismiss()
                
                print("كمل جولة ثانية")
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
            
            Button(action: {
                print("تغيير اللاعبين")
            }) {
                NavigationLink(destination: AddPlayerView()) {
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
            .transition(.opacity)
            .padding(.bottom, 155)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                timerManager.stopAlarm()
            }
        }
    }
}
    
struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(timerManager: TimerManager())
    }
}
