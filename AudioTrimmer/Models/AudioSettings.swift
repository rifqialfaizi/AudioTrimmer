import Foundation

class AudioSettings: ObservableObject {
    @Published var totalTrackLength: Double = 30.0
    @Published var keyTimes: [KeyTime] = [
        KeyTime(id: UUID(), name: "Intro", percentage: 10),
        KeyTime(id: UUID(), name: "Verse", percentage: 25),
        KeyTime(id: UUID(), name: "Chorus", percentage: 50),
        KeyTime(id: UUID(), name: "Bridge", percentage: 75),
        KeyTime(id: UUID(), name: "Outro", percentage: 90)
    ]
}
