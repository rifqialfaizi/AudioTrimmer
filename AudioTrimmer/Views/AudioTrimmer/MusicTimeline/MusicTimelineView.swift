import SwiftUI
import Charts

struct MusicTimelineView: View {
    @ObservedObject var viewModel: AudioTrimmerViewModel
    @ObservedObject var dragState: WaveformDragState
    
    enum Constants {
        static let headerTitle: String = "Music Timeline"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(Constants.headerTitle)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            WaveformTimelineView(viewModel: viewModel, dragState: dragState)
            
            TimelineInfoView(viewModel: viewModel, dragState: dragState)
            
            PlaybackControlsView(viewModel: viewModel)
        }
    }
}

#Preview {
    let settings = AudioSettings()
    let viewModel = AudioTrimmerViewModel(settings: settings)
    let dragState = WaveformDragState()
    
    VStack {
        MusicTimelineView(viewModel: viewModel, dragState: dragState)
            .padding()
        Spacer()
    }
}
