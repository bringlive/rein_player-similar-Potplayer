# Changelog

All notable changes to ReinPlayer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-08

### Added

#### Player Features
- **Context-Aware Keyboard Shortcuts**: Dynamic keyboard system that switches between player and playlist modes based on user interaction
  - Arrow keys control volume when focused on player
  - Arrow keys navigate playlist when focused on playlist panel
  - Single-click interaction automatically switches context
- **Seek Preview Overlay**: Visual preview showing timestamp when seeking through video
  - Displays time info on tooltip during seek operations
  - Works with both adaptive and fixed seek modes
- **Bookmark Management System**: Save and navigate multiple timestamps per video
  - Add bookmarks at any position with custom names (Ctrl+B)
  - Jump between bookmarks using keyboard shortcuts (B, Shift+B)
  - Visual bookmark overlay with edit/delete capabilities (Ctrl+Shift+B)
  - Persistent bookmarks that survive app restarts
  - Automatic sorting by timestamp with wrap-around navigation
- **A-B Loop Segments**: PotPlayer-compatible loop system for practice and repetition
  - Create multiple segments per video with start time and duration
  - Configure loop count and optional repeat delay
  - Visual segment editor with full CRUD operations
  - Import/export PotPlayer Bookmark Files (.pbf)
  - Intelligent playback engine that auto-loops and advances
  - Perfect for language learning, music practice, and sports analysis

#### Playback Features
- **Resume Playback**: Automatically remember and resume from last played timestamp (HH:MM:SS format)
- **Configurable Seek Intervals**: Choose between two seeking modes
  - Adaptive mode: Percentage-based (default 1% and 5%)
  - Fixed mode: Time-based (default 5s and 30s)
  - Fully customizable regular and big seek values
- **Inbuilt Subtitle Selection**: View and switch between embedded subtitle tracks
- **Configurable Double-Click Action**: Choose between:
  - Toggle window size (maximize/minimize) - default
  - Play/Pause video (PotPlayer style)

#### Playlist Features
- **Playlist Context Menu**: Right-click actions for playlist items
  - Delete from disk
  - Copy file path
  - Show in Finder/Nautilus/File Explorer
  - Get file properties
  - Remove from playlist
- **Playlist Load Behavior**: Configure how new files are handled
  - Clear and Replace: New files clear the playlist (default)
  - Append to Existing: Add new files to current playlist
- **Lazy-Loaded Video Durations**: Asynchronous duration loading with auto-formatting
  - Displays as MM:SS for videos under 1 hour
  - Displays as HH:MM:SS for longer videos
- **Playlist Randomization**: Shuffle playlist with keyboard shortcut (S) or context menu

#### Subtitle Features
- **Comprehensive Subtitle Customization**:
  - 12+ font family options
  - Adjustable font size (8-72pt)
  - Position controls (Up/Down/Left/Right)
  - Text alignment (left, center, right)
  - Text and background color pickers
  - Adjustable outline width
  - Real-time preview
  - Settings persist across sessions

#### Settings & Configuration
- **Global Keyboard Shortcuts Toggle**: Enable/disable all keyboard shortcuts with one click
- **Enhanced About Page**: Improved version display for easier bug reporting
- **Playlist End Behavior**: Choose what happens when playlist completes
  - Show home screen (default)
  - Shutdown application

#### macOS Improvements
- **Enhanced macOS Integration**: 
  - Set ReinPlayer as default player via Get Info
  - Double-click video files to launch and play
  - Comprehensive file type associations (video, audio, playlist formats)
  - Improved file opening through Finder

### Fixed
- **macOS Control Overlay Issue**: Resolved control overlay display problems on macOS
- **Maximized Window Playlist Toggle**: Playlist panel now properly adjusts when toggling on maximized windows without leaving empty space
- **CLI Support**: Enhanced command-line argument handling for better file opening

### Improved
- **UI Consistency**: Standardized all alert messages and dialog designs across the application
- **Playlist Item Spacing**: Improved visual spacing between playlist items for better readability
- **Time Counter Display**: Added responsive scaling to prevent text overflow in video type and time counter
- **Navigation Context**: Improved focus management between player and playlist areas

### Changed
- Updated version to 1.1.0
- Improved keyboard shortcut system with context awareness
- Enhanced playlist window resizing logic for maximized windows

---

## [1.0.2] - Previous Release

### Features
- Basic video playback with FFmpeg support
- Playlist management (Default and PotPlayer styles)
- Subtitle support (SRT, VTT)
- Multi-audio track support
- Customizable keyboard shortcuts
- Drag-and-drop support
- Volume control (0-200%)
- Fullscreen mode
- Basic seek functionality

---

## Release Notes

### Installation

Download the appropriate package for your platform from the [releases page](https://github.com/Ahurein/rein_player/releases).

### Upgrading from 1.0.x

This release is fully backward compatible. Your existing settings, playlists, and preferences will be preserved.

### Feedback

Have suggestions or found a bug? Please [open an issue](https://github.com/Ahurein/rein_player/issues) on GitHub.

---

[1.1.0]: https://github.com/Ahurein/rein_player/releases/tag/v1.1.0
[1.0.2]: https://github.com/Ahurein/rein_player/releases/tag/v1.0.2
