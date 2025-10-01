//
//  ContentView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 03/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            HomeView()
        }
    }
}

struct HomeView: View {
    @State private var logoOffset: CGFloat = 0
    @State private var isButtonVisible = false
    
    var body: some View {
        VStack {
            // LOGO - يبقى ظاهراً دائماً
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 450, height: 450)
                .offset(y: logoOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        logoOffset = -200
                    }
                    
                    // إظهار الزر بعد انتهاء حركة اللوقو
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isButtonVisible = true
                        }
                    }
                }
                .padding(.top, 202)
            
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
                        
                        Text("العب")
                            .font(.MainText)
                            .foregroundColor(.white)
                    }
                }
                .transition(.move(edge: .bottom))
                .padding(.bottom, 179)
            }
        }
    }
}

#Preview {
    ContentView()
}
