import Foundation

struct KeyTime: Identifiable, Equatable {
    let id: UUID
    var name: String
    var percentage: Double
    
    var timeInSeconds: Double {
        percentage / 100.0
    }
}
