//
//  EndGameView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct EndGameView: View {
    
    var body: some View {
        VStack {
            
            //padding

            Text("انتهت الجولة")
                .font(.MainText)
                .foregroundColor(.black)
                .padding(.top, 60)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
           //padding
                    Button(action: {
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
                    
            //padding
                        Button(action: {
                            print("تغيير اللاعبين")
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
                
                .transition(.opacity)
                .padding(.bottom, 155)
                
                }
            
            }
         
    
    struct EndGameView_Previews: PreviewProvider {
        static var previews: some View {
            EndGameView()
        }
    }
    

