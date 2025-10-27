import Foundation
import SwiftUI
import Combine

class AudioTrimmerViewModel: ObservableObject {
    @Published var playbackState: PlaybackState = .stopped
    @Published var audioSegment = AudioSegment()
    @Published var settings: AudioSettings
    
    private var playbackTimer: Timer?
    private let playbackUpdateInterval: TimeInterval = 0.1
    
    init(settings: AudioSettings) {
        self.settings = settings
    }
    
    // Time in Seconds
    var currentPlayTimeInSeconds: Double {
        (audioSegment.currentPlayPercentage / 100.0) * settings.totalTrackLength
    }
    
    var segmentStartTimeInSeconds: Double {
        (audioSegment.startPercentage / 100.0) * settings.totalTrackLength
    }
    
    var segmentEndTimeInSeconds: Double {
        (audioSegment.endPercentage / 100.0) * settings.totalTrackLength
    }
    
    var segmentDurationInSeconds: Double {
        segmentEndTimeInSeconds - segmentStartTimeInSeconds
    }
    
    // Percentages
    var currentPositionPercentage: Double {
        audioSegment.currentPlayPercentage
    }
    
    var selectionRangePercentage: String {
        "\(audioSegment.startPercentage.oneDecimal)% - \(audioSegment.endPercentage.oneDecimal)%"
    }
    
    func togglePlayback() {
        switch playbackState {
        case .stopped, .paused:
            play()
        case .playing:
            pause()
        }
    }
    
    func play() {
        playbackState = .playing
        startPlaybackTimer()
    }
    
    func pause() {
        playbackState = .paused
        stopPlaybackTimer()
    }
    
    func stop() {
        playbackState = .stopped
        audioSegment.currentPlayPercentage = audioSegment.startPercentage
        stopPlaybackTimer()
    }
    
    func reset() {
        stop()
    }
    
    func jumpToKeyTime(_ keyTime: KeyTime) {
        // Update the audio segment position to center on the key time
        let segmentDuration = audioSegment.endPercentage - audioSegment.startPercentage
        let newStartPercentage = max(0, min(100 - segmentDuration, keyTime.percentage - segmentDuration / 2))
        
        if playbackState == .playing {
            pause()
        }
        
        // Update all properties to trigger UI updates
        audioSegment.startPercentage = newStartPercentage
        audioSegment.endPercentage = newStartPercentage + segmentDuration
        audioSegment.currentPlayPercentage = audioSegment.startPercentage
    }
    
    func updateSegmentStart(_ percentage: Double) {
        audioSegment.startPercentage = max(0, min(percentage, audioSegment.endPercentage - 1))
        if audioSegment.currentPlayPercentage < audioSegment.startPercentage {
            audioSegment.currentPlayPercentage = audioSegment.startPercentage
        }
    }
    
    func updateSegmentEnd(_ percentage: Double) {
        audioSegment.endPercentage = max(audioSegment.startPercentage + 1, min(100, percentage))
    }
    
    func updateSegmentPosition(to percentage: Double) {
        let segmentDuration = audioSegment.endPercentage - audioSegment.startPercentage
        let newStartPercentage = max(0, min(100 - segmentDuration, percentage))
        
        audioSegment.startPercentage = newStartPercentage
        audioSegment.endPercentage = newStartPercentage + segmentDuration
        audioSegment.currentPlayPercentage = audioSegment.startPercentage
        
        if playbackState == .playing {
            pause()
        }
    }
    
    private func startPlaybackTimer() {
        stopPlaybackTimer()
        playbackTimer = Timer.scheduledTimer(withTimeInterval: playbackUpdateInterval, repeats: true) { _ in
            self.updatePlaybackPosition()
        }
    }
    
    private func stopPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    private func updatePlaybackPosition() {
        let increment = (playbackUpdateInterval / settings.totalTrackLength) * 100
        audioSegment.currentPlayPercentage += increment
        
        // when reached end of segment
        if audioSegment.currentPlayPercentage >= audioSegment.endPercentage {
            stop()
        }
    }
}
