import SwiftUI

struct PlaybackControlsView: View {
    @ObservedObject var viewModel: AudioTrimmerViewModel
        
    private enum Constants {
        enum Text {
            static let reset = "Reset"
            static let stopped = "Stopped"
            static let playing = "Playing"
            static let paused = "Paused"
        }
        
        enum Icon {
            static let reset = "backward.end.fill"
            static let play = "play.circle.fill"
            static let pause = "pause.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 30) {
            Button(action: viewModel.reset) {
                HStack(spacing: 8) {
                    Image(systemName: Constants.Icon.reset)
                    Text(Constants.Text.reset).font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(20)
            }
            .disabled(viewModel.playbackState == .stopped)
            .opacity(viewModel.playbackState == .stopped ? 0.5 : 1.0)
            
            Button(action: viewModel.togglePlayback) {
                Image(systemName: viewModel.playbackState == .playing ? Constants.Icon.pause : Constants.Icon.play)
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                    .scaleEffect(viewModel.playbackState == .playing ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: viewModel.playbackState)
            }
                        
            VStack(alignment: .trailing) {
                Text(playbackStateText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if viewModel.playbackState == .playing {
                    PlaybackIndicatorView()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
    
    private var playbackStateText: String {
        switch viewModel.playbackState {
        case .stopped: Constants.Text.stopped
        case .playing: Constants.Text.playing
        case .paused: Constants.Text.paused
        }
    }
}

#Preview {
    let settings = AudioSettings()
    let viewModel = AudioTrimmerViewModel(settings: settings)
    PlaybackControlsView(viewModel: viewModel).padding()
}
