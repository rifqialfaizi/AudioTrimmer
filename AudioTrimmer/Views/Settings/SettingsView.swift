import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingAudioTrimmer = false
    
    private enum Constants {
        static let navTitle = "Audio Trimmer Settings"
        static let openTrimmer = "Open Trimmer"
        
        // Sections
        static let trackSettings = "Track Settings"
        static let keyTimes = "Key Times"
        
        // Track settings fields
        static let totalTrackLengthLabel = "Total Track Length (seconds)"
        static let totalTrackLengthPlaceholder = "30"
        static let textFieldWidth: CGFloat = 50
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(Constants.trackSettings) {
                    HStack {
                        Text(Constants.totalTrackLengthLabel)
                        Spacer()
                        TextField(Constants.totalTrackLengthPlaceholder, text: $viewModel.totalTrackLengthText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: Constants.textFieldWidth)
                            .keyboardType(.decimalPad)
                            .onChange(of: viewModel.totalTrackLengthText) { _, _ in
                                viewModel.updateTotalTrackLength()
                            }
                    }
                }
                
                Section(Constants.keyTimes) {
                    ForEach(Array(viewModel.settings.keyTimes.enumerated()), id: \.element.id) { index, keyTime in
                        KeyTimeRowView(
                            keyTime: keyTime,
                            onUpdate: { name, percentage in
                                viewModel.updateKeyTime(at: index, name: name, percentage: percentage)
                            }
                        )
                    }
                }
            }
            .navigationTitle(Constants.navTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.openTrimmer) {
                        showingAudioTrimmer = true
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showingAudioTrimmer) {
                AudioTrimmerView(settings: viewModel.settings)
            }
        }
    }
}

#Preview {
    SettingsView()
}
