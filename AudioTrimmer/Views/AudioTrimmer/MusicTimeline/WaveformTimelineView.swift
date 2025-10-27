import SwiftUI

struct WaveformTimelineView: View {
    @ObservedObject var viewModel: AudioTrimmerViewModel
    @ObservedObject var dragState: WaveformDragState
    
    @State private var waveformData: [Double] = []
    @State private var waveformOffset: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var dragStartOffset: CGFloat = 0
    @State private var currentGeometry: GeometryProxy?
    
    private let waveBarWidth: CGFloat = 3
    private let waveBarSpacing: CGFloat = 2
    private let waveBarHeight: CGFloat = 50
    private let selectionWidth: CGFloat = 300
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background waveform
                HStack(spacing: waveBarSpacing) {
                    ForEach(Array(waveformData.enumerated()), id: \.offset) { _, amplitude in
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: waveBarWidth, height: CGFloat(amplitude) * (waveBarHeight / 2))
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: waveBarWidth, height: CGFloat(amplitude) * (waveBarHeight / 2))
                        }
                        .frame(height: waveBarHeight)
                    }
                }
                .offset(x: waveformOffset + dragOffset)
                .clipped()
                
                // Blue selection frame
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.2))
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: selectionWidth, height: waveBarHeight + 10)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .allowsHitTesting(false)
                
                // Highlight waveform into blue inside selection
                HStack(spacing: waveBarSpacing) {
                    ForEach(Array(waveformData.enumerated()), id: \.offset) { _, amplitude in
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: waveBarWidth, height: CGFloat(amplitude) * (waveBarHeight / 2))
                            Rectangle()
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: waveBarWidth, height: CGFloat(amplitude) * (waveBarHeight / 2))
                        }
                        .frame(height: waveBarHeight)
                    }
                }
                .offset(x: waveformOffset + dragOffset)
                .mask(
                    Rectangle()
                        .frame(width: selectionWidth, height: waveBarHeight)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                )
                .allowsHitTesting(false)
                
                // Play progress
                let currentStartPercentage = dragState.isDragging ? dragState.localStartPercentage : viewModel.audioSegment.startPercentage
                let currentEndPercentage = dragState.isDragging ? dragState.localEndPercentage : viewModel.audioSegment.endPercentage
                let currentPlayPercentage = dragState.isDragging ? dragState.localCurrentPercentage : viewModel.audioSegment.currentPlayPercentage
                
                let playProgress = (currentPlayPercentage - currentStartPercentage) / (currentEndPercentage - currentStartPercentage)
                let progressWidth = CGFloat(max(0, min(1, playProgress))) * selectionWidth
                let selectionStartX = geometry.size.width / 2 - selectionWidth / 2
                
                // Orange progress when playing
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange.opacity(0.7), Color.red.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: progressWidth, height: waveBarHeight + 7)
                    .position(
                        x: (selectionStartX + progressWidth / 2) + 1,
                        y: geometry.size.height / 2
                    )
                    .allowsHitTesting(false)
                    .animation(.linear(duration: dragState.isDragging ? 0 : 0.1), value: progressWidth)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onChanged { value in
                        if !dragState.isDragging {
                            dragState.isDragging = true
                            dragStartOffset = waveformOffset
                            
                            dragState.updatePercentages(
                                start: viewModel.audioSegment.startPercentage,
                                end: viewModel.audioSegment.endPercentage,
                                current: viewModel.audioSegment.startPercentage
                            )
                            
                            if viewModel.playbackState == .playing {
                                viewModel.pause()
                            }
                        }
                        updateLocalStateAndOffset(translation: value.translation.width, geometry: geometry)
                    }
                    .onEnded { value in
                        updateFinalPosition(translation: value.translation.width, geometry: geometry)
                        dragState.isDragging = false
                    }
            )
            .onAppear {
                currentGeometry = geometry
            }
            .onChange(of: geometry.size) { _, _ in
                currentGeometry = geometry
            }
        }
        .frame(height: waveBarHeight + 30)
        .onAppear {
            generateWaveformData()
            syncLocalStateWithViewModel()
        }
        .onChange(of: viewModel.audioSegment.startPercentage) { _, _ in
            if !dragState.isDragging {
                syncLocalStateWithViewModel()
                if let geometry = currentGeometry {
                    updateWaveformForKeyTimeJump(geometry: geometry)
                }
            }
        }
    }
}

private extension WaveformTimelineView {
    func generateWaveformData() {
        waveformData = (0..<150).map { i in
            let wavePattern = sin(Double(i) * 0.5)
            let uniformAmplitude = 0.6
            return abs(wavePattern) * uniformAmplitude
        }
    }
    
    func syncLocalStateWithViewModel() {
        dragState.updatePercentages(
            start: viewModel.audioSegment.startPercentage,
            end: viewModel.audioSegment.endPercentage,
            current: viewModel.audioSegment.currentPlayPercentage
        )
    }
    
    func updateLocalStateAndOffset(translation: CGFloat, geometry: GeometryProxy) {
        let newOffset = dragStartOffset + translation
        let totalWaveformWidth = CGFloat(waveformData.count) * (waveBarWidth + waveBarSpacing)
        let selectionLeftEdge = (geometry.size.width - selectionWidth) / 2
        let maxOffset = selectionLeftEdge
        let minOffset = selectionLeftEdge - (totalWaveformWidth - selectionWidth)
        
        waveformOffset = max(minOffset, min(maxOffset, newOffset))
        
        let percentage = calculatePercentageFromOffset(waveformOffset, geometry: geometry)
        let segmentDuration = dragState.localEndPercentage - dragState.localStartPercentage
        let newStartPercentage = max(0, min(100 - segmentDuration, percentage))
        
        dragState.updatePercentages(
            start: newStartPercentage,
            end: newStartPercentage + segmentDuration,
            current: newStartPercentage
        )
    }
    
    func updateFinalPosition(translation: CGFloat, geometry: GeometryProxy) {
        let newOffset = dragStartOffset + translation
        let totalWaveformWidth = CGFloat(waveformData.count) * (waveBarWidth + waveBarSpacing)
        let selectionLeftEdge = (geometry.size.width - selectionWidth) / 2
        let maxOffset = selectionLeftEdge
        let minOffset = selectionLeftEdge - (totalWaveformWidth - selectionWidth)
        
        waveformOffset = max(minOffset, min(maxOffset, newOffset))
        
        let percentage = calculatePercentageFromOffset(waveformOffset, geometry: geometry)
        viewModel.updateSegmentPosition(to: percentage)
        
        syncLocalStateWithViewModel()
    }
    
    func calculatePercentageFromOffset(_ offset: CGFloat, geometry: GeometryProxy) -> Double {
        let totalWaveformWidth = CGFloat(waveformData.count) * (waveBarWidth + waveBarSpacing)
        let selectionLeftEdge = (geometry.size.width - selectionWidth) / 2
        
        let maxOffset = selectionLeftEdge
        let minOffset = selectionLeftEdge - (totalWaveformWidth - selectionWidth)
        
        let normalizedPosition = (maxOffset - offset) / (maxOffset - minOffset)
        let percentage = normalizedPosition * 100
        
        return max(0, min(100, percentage))
    }
    
    func updateWaveformForKeyTimeJump(geometry: GeometryProxy) {
        let targetPercentage = viewModel.audioSegment.startPercentage
        let newOffset = calculateOffsetFromPercentage(targetPercentage, geometry: geometry)
        withAnimation(.easeInOut(duration: 0.3)) {
            waveformOffset = newOffset
        }
    }
    
    func calculateOffsetFromPercentage(_ percentage: Double, geometry: GeometryProxy) -> CGFloat {
        let totalWaveformWidth = CGFloat(waveformData.count) * (waveBarWidth + waveBarSpacing)
        let selectionLeftEdge = (geometry.size.width - selectionWidth) / 2
        
        let maxOffset = selectionLeftEdge
        let minOffset = selectionLeftEdge - (totalWaveformWidth - selectionWidth)
        
        let targetOffset = maxOffset - (CGFloat(percentage) / 100.0) * (maxOffset - minOffset)
        
        return max(minOffset, min(maxOffset, targetOffset))
    }
}

#Preview {
    let settings = AudioSettings()
    let viewModel = AudioTrimmerViewModel(settings: settings)
    let dragState = WaveformDragState()
    WaveformTimelineView(viewModel: viewModel, dragState: dragState).padding()
}
