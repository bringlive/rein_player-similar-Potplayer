import 'package:rein_player/utils/constants/rp_enums.dart';
import 'package:rein_player/utils/constants/rp_keys.dart';

class Settings {
  bool isSubtitleEnabled;
  PlaylistType playlistType;
  DoubleClickAction doubleClickAction;
  PlaylistLoadBehavior playlistLoadBehavior;

  Settings({
    this.isSubtitleEnabled = true,
    this.playlistType = PlaylistType.defaultPlaylistType,
    this.doubleClickAction = DoubleClickAction.toggleWindowSize,
    this.playlistLoadBehavior = PlaylistLoadBehavior.clearAndReplace,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    PlaylistType savedPlaylistType = PlaylistType.values.byName(
        json[RpKeysConstants.playlistTypeStorageKey] ??
            PlaylistType.defaultPlaylistType.name);

    DoubleClickAction savedDoubleClickAction = DoubleClickAction.values.byName(
        json[RpKeysConstants.doubleClickActionKey] ??
            DoubleClickAction.toggleWindowSize.name);

    PlaylistLoadBehavior savedPlaylistLoadBehavior = PlaylistLoadBehavior.values.byName(
        json[RpKeysConstants.playlistLoadBehaviorKey] ??
            PlaylistLoadBehavior.clearAndReplace.name);

    return Settings(
      isSubtitleEnabled:
          json[RpKeysConstants.subtitleEnabledStorageKey] as bool? ?? false,
      playlistType: savedPlaylistType,
      doubleClickAction: savedDoubleClickAction,
      playlistLoadBehavior: savedPlaylistLoadBehavior,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RpKeysConstants.subtitleEnabledStorageKey: isSubtitleEnabled,
      RpKeysConstants.playlistTypeStorageKey: playlistType.name,
      RpKeysConstants.doubleClickActionKey: doubleClickAction.name,
      RpKeysConstants.playlistLoadBehaviorKey: playlistLoadBehavior.name,
    };
  }

  Map<String, dynamic> defaultSettings() {
    return toJson();
  }
}
