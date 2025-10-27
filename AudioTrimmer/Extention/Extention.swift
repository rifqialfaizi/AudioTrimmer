import Foundation

extension Double {
    var oneDecimal: String {
        self.formatted(.number.precision(.fractionLength(1)))
    }
    
    var noDecimal: String {
        self.formatted(.number.precision(.fractionLength(0)))
    }
}
