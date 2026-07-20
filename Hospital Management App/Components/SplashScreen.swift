import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var isAnimating = false
    
    var body: some View {
        if isActive {
            RootTabView()
        } else {
            ZStack {
              
                LinearGradient(
                    colors: [Color(red: 0.04, green: 0.06, blue: 0.15), Color(red: 0.08, green: 0.15, blue: 0.30)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(red: 0.0, green: 0.9, blue: 0.9))
                        .shadow(color: Color(red: 0.0, green: 0.9, blue: 0.9).opacity(0.6), radius: 15)
                        .scaleEffect(isAnimating ? 1.0 : 0.7)
                        .opacity(isAnimating ? 1.0 : 0.0)
                    
                    Text("CareFlow")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(1.5)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : 15)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                    isAnimating = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
