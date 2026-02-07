import 'package:rein_player/utils/constants/rp_enums.dart';
import 'package:rein_player/utils/constants/rp_keys.dart';

class Settings {
  bool isSubtitleEnabled;
  PlaylistType playlistType;
  DoubleClickAction doubleClickAction;

  Settings({
    this.isSubtitleEnabled = true,
    this.playlistType = PlaylistType.defaultPlaylistType,
    this.doubleClickAction = DoubleClickAction.toggleWindowSize,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    PlaylistType savedPlaylistType = PlaylistType.values.byName(
        json[RpKeysConstants.playlistTypeStorageKey] ??
            PlaylistType.defaultPlaylistType.name);

    DoubleClickAction savedDoubleClickAction = DoubleClickAction.values.byName(
        json[RpKeysConstants.doubleClickActionKey] ??
            DoubleClickAction.toggleWindowSize.name);

    return Settings(
      isSubtitleEnabled:
          json[RpKeysConstants.subtitleEnabledStorageKey] as bool? ?? false,
      playlistType: savedPlaylistType,
      doubleClickAction: savedDoubleClickAction,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RpKeysConstants.subtitleEnabledStorageKey: isSubtitleEnabled,
      RpKeysConstants.playlistTypeStorageKey: playlistType.name,
      RpKeysConstants.doubleClickActionKey: doubleClickAction.name,
    };
  }

  Map<String, dynamic> defaultSettings() {
    return toJson();
  }
}
