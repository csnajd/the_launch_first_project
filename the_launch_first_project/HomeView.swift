//
//  HomeView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct HomeView: View {
    @State private var logoOffset: CGFloat = 0
    @State private var isButtonVisible = false
    
    var body: some View {
        VStack {
            
            padding (.top,202)
            // LOGO
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 450, height: 450)
                .offset(y: logoOffset)
                
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        logoOffset = -200
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isButtonVisible = true
                    }
                }
            
            Spacer()
                
               if isButtonVisible {
                   Button(action: {
                       print("العب")
                   }) {
                      
                       ZStack{
                           Image("purpleBS")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 227, height: 55)
                               .border(Color.red, width: 1)
                           
                           Text("العب")
                               .font(.MainText)
                               .foregroundColor(.white)
                               .border(Color.red, width: 1)
                           
                       }
                   }
                   
                   .transition(.move(edge: .bottom))
                   .padding(.bottom, 179)
               }
               
           }
       }
   }
 

#Preview {
    HomeView()
}
