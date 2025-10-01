//
//  RoleView.swift
//  the_launch_first_project
//
//  Created by najd aljarba on 06/04/1447 AH.
//
import SwiftUI
struct RoleView: View {
    // قائمة الأدوار
    let roles = ["محمد", "سارة", "نورة", "العجوز"]
    
    // نخزن الدور المختار
    @State private var selectedRole: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            
            if let role = selectedRole {
                // اسم الدور
                Text(role)
                    .font(.custom("MainText", size: 28))
                    .bold()
                
                // التعليمات
                Text(instructions(for: role))
                    .font(.custom("MainText", size: 24))
                    .multilineTextAlignment(.center)
                    .padding()
                
                // زر يلا
                Button(action: {
                    print("اللاعب اختار الدور: \(role)")
                }) {
                    ZStack {
                        Image("purpleBL") // البوتوم من الأسيست
                            .resizable()
                            .frame(width: 200, height: 55)
                        
                        Text("يلا")
                            .font(.custom("MainText", size: 24))
                            .foregroundColor(.white)
                    }
                }
                
            } else {
                // زر يختار الدور
                Button(action: {
                    selectedRole = roles.randomElement()
                }) {
                    ZStack {
                        Image("purpleBL")
                            .resizable()
                            .frame(width: 200, height: 55)
                        
                        Text("اختر دورك")
                            .font(.custom("MainText", size: 24))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
    }
    
    // دالة التعليمات حسب الدور
    func instructions(for role: String) -> String {
        switch role {
        case "محمد":
            return "لازم تتابع اللاعبين وتقفط الولد عشان تحمي بنتك"
        case "سارة":
            return "لازم تحاول تعرف مين البنات عشان تحميهم وتبعديهم عن العجوز لا تفصلها"
        case "نورة":
            return "لازم تنتبهين للولد لما يختبئ وتحاولين تحمين خطيبتك"
        case "العجوز":
            return "انت العجوز 👵 لازم تخطط وتخلي الباقي ينكشفوا"
        default:
            return "دورك غير معروف"
        }
    }
}

#Preview {
    RoleView()
}

