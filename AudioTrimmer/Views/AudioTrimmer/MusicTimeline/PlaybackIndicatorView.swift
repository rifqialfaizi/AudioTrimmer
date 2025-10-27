import SwiftUI

struct PlaybackIndicatorView: View {
    @State private var animationScale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.blue)
                    .frame(width: 4, height: 4)
                    .scaleEffect(animationScale)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: animationScale
                    )
            }
        }
        .onAppear { animationScale = 1.5 }
    }
}

#Preview {
    PlaybackIndicatorView().padding()
}