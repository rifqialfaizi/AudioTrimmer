import SwiftUI

struct KeyTimeRowView: View {
    @State private var name: String
    @State private var percentageText: String
    
    let onUpdate: (String, Double) -> Void
    
    private enum Constants {
        static let namePlaceholder = "Name"
        static let percentagePlaceholder = "0"
        static let percentageSymbol = "%"
        static let textFieldWidth: CGFloat = 50
        
        enum SFSymbol {
            static let trash = "trash"
        }
    }
    
    init(keyTime: KeyTime, onUpdate: @escaping (String, Double) -> Void) {
        _name = State(initialValue: keyTime.name)
        _percentageText = State(initialValue: FormatHelper.formatNumber(keyTime.percentage))
        self.onUpdate = onUpdate
    }
    
    var body: some View {
        HStack {
            TextField(Constants.namePlaceholder, text: $name)
                .onChange(of: name) { _, _ in
                    updateKeyTime()
                }
            
            Spacer()
            
            TextField(Constants.percentagePlaceholder, text: $percentageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: Constants.textFieldWidth)
                .keyboardType(.decimalPad)
                .onChange(of: percentageText) { _, _ in
                    updateKeyTime()
                }
            
            Text(Constants.percentageSymbol)
        }
    }
    
    private func updateKeyTime() {
        let percentage = Double(percentageText) ?? 0.0
        onUpdate(name, percentage)
    }
}

#Preview {
    KeyTimeRowView(
        keyTime: KeyTime(id: UUID(), name: "Intro", percentage: 10),
        onUpdate: { _, _ in }
    )
    .padding()
}
