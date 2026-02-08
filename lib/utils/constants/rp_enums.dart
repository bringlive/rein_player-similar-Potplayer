enum PlaylistType {
  defaultPlaylistType,
  potPlayerPlaylistType,
}

enum DoubleClickAction {
  toggleWindowSize,
  playPause,
}

enum SeekMode {
  adaptive,
  fixed,
}

enum PlaylistLoadBehavior {
  clearAndReplace,
  appendToExisting,
}

enum ActionContext {
  player,
  playlist
}

enum PlaylistEndBehavior {
  showHomeScreen,
  shutdown,
}