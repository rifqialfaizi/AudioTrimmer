import SwiftUI

struct TimelineInfoView: View {
    @ObservedObject var viewModel: AudioTrimmerViewModel
    @ObservedObject var dragState: WaveformDragState
    
    enum Constants {
        enum Text {
            static let startAudioTimeLabel: String = "Start"
            static let endAudioTimeLabel: String = "End"
            static let currentAudioTimeLabel: String = "Current"
            static let durationAudioTimeLabel: String = "Duration"
        }
        
        enum Icon {
            static let start = "arrow.right.circle.fill"
            static let end = "arrow.left.circle.fill"
            static let current = "clock.fill"
            static let duration = "timer"
        }
    }
    
    private var display: DisplayValueProvider {
        DisplayValueProvider(dragState: dragState, viewModel: viewModel)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Label("\(Constants.Text.startAudioTimeLabel): \(display.displayStartTimeInSeconds.oneDecimal)s",
                      systemImage: Constants.Icon.start)
                Label("\(Constants.Text.endAudioTimeLabel): \(display.displayEndTimeInSeconds.oneDecimal)s",
                      systemImage: Constants.Icon.end)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Label("\(Constants.Text.currentAudioTimeLabel): \(display.displayCurrentTimeInSeconds.oneDecimal)s",
                      systemImage: Constants.Icon.current)
                Label("\(Constants.Text.durationAudioTimeLabel): \(display.displayDurationInSeconds.oneDecimal)s",
                      systemImage: Constants.Icon.duration)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    let settings = AudioSettings()
    let viewModel = AudioTrimmerViewModel(settings: settings)
    let dragState = WaveformDragState()
    TimelineInfoView(viewModel: viewModel, dragState: dragState).padding()
}
