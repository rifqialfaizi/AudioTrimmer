import Foundation
import Combine

class WaveformDragState: ObservableObject {
    @Published var isDragging: Bool = false
    @Published var localStartPercentage: Double = 0
    @Published var localEndPercentage: Double = 30
    @Published var localCurrentPercentage: Double = 0
    
    private var updateTimer: Timer?
    private var pendingUpdate: (() -> Void)?
    
    var liveStartPercentage: Double? {
        isDragging ? localStartPercentage : nil
    }
    
    var liveEndPercentage: Double? {
        isDragging ? localEndPercentage : nil
    }
    
    var liveCurrentPercentage: Double? {
        isDragging ? localCurrentPercentage : nil
    }
    
    func updatePercentages(start: Double, end: Double, current: Double) {
        // Update immediately for first touch
        if !isDragging {
            localStartPercentage = start
            localEndPercentage = end
            localCurrentPercentage = current
            return
        }
        
        pendingUpdate = { [weak self] in
            self?.localStartPercentage = start
            self?.localEndPercentage = end
            self?.localCurrentPercentage = current
        }
        
        if updateTimer == nil {
            pendingUpdate?()
            pendingUpdate = nil
            
            // 1000ms / 60fps ≈ 0.016s, max 60 updates per second
            updateTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: false) { [weak self] _ in
                self?.pendingUpdate?()
                self?.pendingUpdate = nil
                self?.updateTimer = nil
            }
        }
    }
    
    deinit {
        updateTimer?.invalidate()
    }
}
