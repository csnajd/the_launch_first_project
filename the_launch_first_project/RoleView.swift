import SwiftUI

struct RoleView: View {
    let allRoles = ["الولد", "البنت", "العجوز"]
    @State private var remainingRoles: [String] = ["الولد", "البنت", "العجوز"]
    @State private var selectedRole: String? = nil
    @State private var rolesFinished = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let role = selectedRole {
                Text(role)
                    .font(.custom("MainText", size: 28))
                    .bold()
                
                Text(instructions(for: role))
                    .font(.custom("MainText", size: 24))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                    selectedRole = nil
                    if remainingRoles.isEmpty {
                        rolesFinished = true
                    }
                }) {
                    ZStack {
                        Image("purpleBL")
                            .resizable()
                            .frame(width: 200, height: 55)
                        Text("التالي")
                            .font(.custom("MainText", size: 24))
                            .foregroundColor(.white)
                    }
                }
            } else {
                if !rolesFinished {
                    Button(action: {
                        if let newRole = remainingRoles.randomElement() {
                            selectedRole = newRole
                            remainingRoles.removeAll { $0 == newRole }
                        }
                    }) {
                        ZStack {
                            Image("purpleBL")
                                .resizable()
                                .frame(width: 200, height: 55)
                            Text("اعرف دورك !")
                                .font(.custom("MainText", size: 24))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    func instructions(for role: String) -> String {
        switch role {
        case "الولد":
            return "لازم تحاول تعرف مين البنات عشان تخطبهم وانتبه من العجوز لا تقفطك!"
        case "البنت":
            return "لازم تنتبهين للولد لما يخطبك وتعلنين خطبتك!"
        case "العجوز":
            return "لازم تراقب اللاعبين وتقفط الولد عشان تحمي بناتك!"
        default:
            return "دورك غير معروف"
        }
    }
}

#Preview {
    RoleView()
}


