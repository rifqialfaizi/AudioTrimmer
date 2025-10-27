import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var settings = AudioSettings()
    @Published var totalTrackLengthText: String = "30"
    
    init() {
        totalTrackLengthText = FormatHelper.formatNumber(settings.totalTrackLength)
    }
    
    func updateTotalTrackLength() {
        if let value = Double(totalTrackLengthText), value > 0 {
            settings.totalTrackLength = value
        }
    }
    
    func updateKeyTime(at index: Int, name: String, percentage: Double) {
        if index < settings.keyTimes.count {
            settings.keyTimes[index].name = name
            settings.keyTimes[index].percentage = max(0, min(100, percentage))
        }
    }
}
