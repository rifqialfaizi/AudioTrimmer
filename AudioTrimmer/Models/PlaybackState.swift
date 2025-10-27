import Foundation

enum PlaybackState {
    case stopped
    case playing
    case paused
}

struct AudioSegment {
    var startPercentage: Double = 0.0
    var endPercentage: Double = 20.0
    var currentPlayPercentage: Double = 0.0
}
