//
//  TimeView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//

import SwiftUI

struct TimeView: View {
    var body: some View {
        VStack(spacing: 20) {
            // العنوان
            Text("وقت اللعب !!")
                .font(.MainText)
                .padding(.top, 40)
            
            // العبارة تحت العنوان
            Text("اضغط يلا عشان يبدا المؤقت\n(يمديك تختار الوقت بس اكثر شي ٣ دقايق)")
                .multilineTextAlignment(.center)
                .font(.PlayerText)
                .padding(.horizontal)
            
            Spacer() // يرفع الصورة للنص تقريبًا
            
            // صورة الساعة
            Image("Clock")
                .resizable()
                .scaledToFit()
                .frame(width: 277, height: 277)
                .padding(.bottom, 40)
            
            // زر "يلا" مع نص فوق الصورة
            ZStack {
                Image("purpleBS")             // صورة الزر من Assets
                    .resizable()
                    .frame(width: 277, height: 55)
                    .cornerRadius(10)
                
                Text("يلا")                    // النص على الزر
                    .font(.MainText)
                    .foregroundColor(.white)
            }
            .onTapGesture {
                print("تم الضغط على يلا")
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    TimeView()
}

