import SwiftUI

struct KeyTimeSelectionView: View {
    @ObservedObject var viewModel: AudioTrimmerViewModel
    @ObservedObject var dragState: WaveformDragState
        
    private enum Constants {
        enum Text {
            static let title = "Key Time Selection"
            static let timelineSelection = "Timeline Selection:"
            static let currentPlayTime = "Current Play Time:"
        }
    }
    
    private var display: DisplayValueProvider {
        DisplayValueProvider(dragState: dragState, viewModel: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(Constants.Text.title)
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.settings.keyTimes) { keyTime in
                        KeyTimeButtonView(
                            keyTime: keyTime,
                            isSelected: dragState.isDragging ? false : display.isKeyTimeNearSelection(keyTime)
                        ) {
                            viewModel.jumpToKeyTime(keyTime)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollDisabled(true)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(Constants.Text.timelineSelection)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(display.selectionRangeText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .monospacedDigit()
                }
                
                HStack {
                    Text(Constants.Text.currentPlayTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(display.formattedCurrentPercentage)%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .monospacedDigit()
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

#Preview {
    let settings = AudioSettings()
    let viewModel = AudioTrimmerViewModel(settings: settings)
    let dragState = WaveformDragState()
    
    KeyTimeSelectionView(viewModel: viewModel, dragState: dragState)
        .padding()
}
