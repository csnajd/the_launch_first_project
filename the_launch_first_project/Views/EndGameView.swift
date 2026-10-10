
import SwiftUI

struct EndGameView: View {
    @Binding var navigationPath: NavigationPath
    
    /// ViewModel that encapsulates end-game interactions & navigation.
    @StateObject private var viewModel: EndGameViewModel
    
    init(timerManager: TimerManager, navigationPath: Binding<NavigationPath>, playerNames: [String]) {
        self._navigationPath = navigationPath
        _viewModel = StateObject(wrappedValue: EndGameViewModel(timerManager: timerManager, playerNames: playerNames))
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 100)
                
                Text("انتهت الجولة")
                    .font(.MainText)
                    .foregroundColor(.black)
                
                Spacer()

                Button(action: {
                    viewModel.playAnotherRound(navigationPath: $navigationPath)
                }) {
                    ZStack {
                        Image("blueB")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359, height: 60)
                            .contentShape(Rectangle())
                        Text("كمل جولة ثانية")
                            .font(.PlayerText).font(.system(.title3, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 5)

                Button(action: {
                    viewModel.changePlayers(navigationPath: $navigationPath)
                }) {
                    ZStack {
                        Image("purpleBL")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359, height: 59)
                        Text("تغيير اللاعبين")
                            .font(.PlayerText)
                            .foregroundColor(.white).shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                }
            }
            .padding(.bottom, 60)
            .padding(.horizontal, 8)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.onAppear()
            }
        }
        .withHomeButton(navigationPath: $navigationPath)
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(
            timerManager: TimerManager(),
            navigationPath: .constant(NavigationPath()),
            playerNames: ["أحمد", "سارة", "منى", "خالد"]  
        )
    }
}
