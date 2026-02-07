import 'package:get/get.dart';
import 'package:rein_player/features/developer/controller/developer_log_controller.dart';
import 'package:rein_player/features/playback/controller/audio_track_controller.dart';
import 'package:rein_player/features/playback/controller/ab_loop_controller.dart';
import 'package:rein_player/features/playback/controller/bookmark_controller.dart';
import 'package:rein_player/features/playback/controller/playlist_type_controller.dart';
import 'package:rein_player/features/playback/controller/subtitle_controller.dart';
import 'package:rein_player/features/playback/controller/video_and_controls_controller.dart';
import 'package:rein_player/features/playback/controller/controls_controller.dart';
import 'package:rein_player/features/playback/controller/volume_controller.dart';
import 'package:rein_player/features/playback/controller/playback_speed_controller.dart';
import 'package:rein_player/features/playback/controller/seek_preview_controller.dart';
import 'package:rein_player/features/player_frame/controller/window_actions_controller.dart';
import 'package:rein_player/features/player_frame/controller/fullscreen_overlay_controller.dart';
import 'package:rein_player/features/playlist/controller/album_controller.dart';
import 'package:rein_player/features/settings/controller/menu_controller.dart';
import 'package:rein_player/features/settings/controller/settings_controller.dart';
import 'package:rein_player/features/settings/controller/seek_settings_controller.dart';
import 'package:rein_player/features/settings/controller/keyboard_preferences_controller.dart';
import 'package:rein_player/features/settings/controller/subtitle_styling_controller.dart';

import '../features/player_frame/controller/window_controller.dart';
import '../features/player_frame/controller/window_info_controller.dart';
import '../features/playlist/controller/album_content_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DeveloperLogController());
    Get.put(KeyboardPreferencesController());
    Get.put(WindowController());
    Get.put(SubtitleController());
    Get.put(SubtitleStylingController());
    Get.put(AudioTrackController());
    Get.put(ControlsController());
    Get.put(VideoAndControlController());
    Get.put(BookmarkController());
    Get.put(ABLoopController());
    Get.put(WindowActionsController());
    Get.put(FullscreenOverlayController());
    Get.put(VolumeController());
    Get.put(PlaybackSpeedController());
    Get.put(SeekPreviewController());
    Get.put(WindowInfoController());
    Get.put(AlbumController());
    Get.put(AlbumContentController());
    Get.put(MainMenuController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => SeekSettingsController());
    Get.lazyPut(() => PlaylistTypeController());
  }
}
