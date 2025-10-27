import SwiftUI

struct KeyTimeButtonView: View {
    let keyTime: KeyTime
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(keyTime.name)
                    .font(.caption)
                    .fontWeight(.medium)
                Text("\(keyTime.percentage.noDecimal)%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1)
            )
            .foregroundColor(isSelected ? .white : .blue)
            .cornerRadius(8)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack(spacing: 12) {
        KeyTimeButtonView(
            keyTime: KeyTime(id: UUID(), name: "Intro", percentage: 10),
            isSelected: false,
            action: {}
        )
        
        KeyTimeButtonView(
            keyTime: KeyTime(id: UUID(), name: "Chorus", percentage: 50),
            isSelected: true,
            action: {}
        )
    }
    .padding()
}
