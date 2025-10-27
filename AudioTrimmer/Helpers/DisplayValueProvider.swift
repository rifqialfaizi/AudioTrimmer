import Foundation

struct DisplayValueProvider {
    let dragState: WaveformDragState
    let viewModel: AudioTrimmerViewModel
    
    // Percentages
    var displayStartPercentage: Double {
        dragState.liveStartPercentage ?? viewModel.audioSegment.startPercentage
    }
    
    var displayEndPercentage: Double {
        dragState.liveEndPercentage ?? viewModel.audioSegment.endPercentage
    }
    
    var displayCurrentPercentage: Double {
        dragState.liveCurrentPercentage ?? viewModel.audioSegment.currentPlayPercentage
    }
    
    // Time in Seconds
    var displayStartTimeInSeconds: Double {
        (displayStartPercentage / 100.0) * viewModel.settings.totalTrackLength
    }
    
    var displayEndTimeInSeconds: Double {
        (displayEndPercentage / 100.0) * viewModel.settings.totalTrackLength
    }
    
    var displayCurrentTimeInSeconds: Double {
        (displayCurrentPercentage / 100.0) * viewModel.settings.totalTrackLength
    }
    
    var displayDurationInSeconds: Double {
        displayEndTimeInSeconds - displayStartTimeInSeconds
    }
    
    // Formatted Strings
    var selectionRangeText: String {
        "\(displayStartPercentage.oneDecimal)% - \(displayEndPercentage.oneDecimal)%"
    }
    
    var formattedCurrentPercentage: String {
        displayCurrentPercentage.oneDecimal
    }
    
    // Helper
    func isKeyTimeNearSelection(_ keyTime: KeyTime, tolerance: Double = 10.0) -> Bool {
        let selectionCenter = (displayStartPercentage + displayEndPercentage) / 2
        return abs(keyTime.percentage - selectionCenter) <= tolerance
    }
}
