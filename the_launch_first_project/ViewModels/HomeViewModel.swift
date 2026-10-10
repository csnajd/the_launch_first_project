import SwiftUI

/// ViewModel backing the home screen, responsible for simple intro animation state.
final class HomeViewModel: ObservableObject {
    
    /// Controls the visibility of the primary action button.
    @Published var isButtonVisible: Bool = false
    
    /// Triggers the logo haptic and reveals the play button after a short delay.
    func handleLogoAppear() {
        let hapticGenerator = UIImpactFeedbackGenerator(style: .light)
        hapticGenerator.prepare()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hapticGenerator.impactOccurred()
            withAnimation {
                self.isButtonVisible = true
            }
        }
    }
}

