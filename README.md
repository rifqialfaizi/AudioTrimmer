# Audio Trimmer 🎧

A SwiftUI-based iOS audio trimmer app that simulates audio editing functionality.

## Features

- 🎵 Configure total track length and key time points
- 🎨 Interactive waveform with drag-and-drop interface
- ▶️ Playback controls with real-time progress visualization
- ⚡ Quick navigation using predefined key time buttons
- 📊 Real-time display of timing information

## Requirements

- iOS 18.5+
- Xcode 16.4+
- Swift 5.0+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/AudioTrimmer.git
cd AudioTrimmer
```

2. Open in Xcode:
```bash
open AudioTrimmer.xcodeproj
```

3. Build and run (⌘ + R)

## Usage

### Settings Screen
1. Set the total track length in seconds
2. Configure key times (name and percentage position)
3. Tap "Open Trimmer" to proceed

### Audio Trimmer Screen
1. **Navigate**: Tap key time buttons to jump to positions
2. **Adjust**: Drag the waveform to reposition the segment
3. **Playback**: Use play/pause and reset controls
4. **Monitor**: View timing details in the info panel

## Architecture

MVVM pattern with:
- **Models**: `AudioSettings`, `KeyTime`, `PlaybackState`, `WaveformDragState`
- **ViewModels**: `AudioTrimmerViewModel`, `SettingsViewModel`
- **Views**: Settings, Audio Trimmer, Timeline, KeyTime components
- **Helpers**: `DisplayValueProvider`, format utilities

## Project Structure

```
AudioTrimmer/
├── Models/           # Data models
├── ViewModels/       # Business logic
├── Views/            # UI components
├── Helpers/          # Utilities
└── Extention/        # Swift extensions
```

## Author

Rifqi Alfaizi
