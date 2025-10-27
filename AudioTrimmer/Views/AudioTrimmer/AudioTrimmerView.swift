import SwiftUI

struct AudioTrimmerView: View {
    @StateObject private var viewModel: AudioTrimmerViewModel
    @StateObject private var waveformDragState = WaveformDragState()
    @Environment(\.dismiss) private var dismiss
    
    enum Constants {
        static let headerTitle: String = "Audio Trimmer"
        static let closeButton: String = "Close"
    }
    
    init(settings: AudioSettings) {
        _viewModel = StateObject(wrappedValue: AudioTrimmerViewModel(settings: settings))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    KeyTimeSelectionView(viewModel: viewModel, dragState: waveformDragState)
                    
                    MusicTimelineView(viewModel: viewModel, dragState: waveformDragState)
                }
                .padding()
            }
            .navigationTitle(Constants.headerTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Settings") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    let settings = AudioSettings()
    AudioTrimmerView(settings: settings)
}
