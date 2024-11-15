import SwiftUI



struct WelcomePage: View {
    @State private var isActive = false  // State to trigger the transition

    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                Image(.welcome)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 1000, height: 200) // Set
                    .background(Color(.white))
                    .onAppear {
                        // Delay navigation for 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .transition(.opacity)
    }
}



#Preview {
    MainPage()
}
