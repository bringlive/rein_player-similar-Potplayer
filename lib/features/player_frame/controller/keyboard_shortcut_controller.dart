import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rein_player/common/widgets/rp_snackbar.dart';
import 'package:rein_player/features/developer/controller/developer_log_controller.dart';
import 'package:rein_player/features/playback/controller/controls_controller.dart';
import 'package:rein_player/features/playback/controller/playback_speed_controller.dart';
import 'package:rein_player/features/playback/controller/subtitle_controller.dart';
import 'package:rein_player/features/playback/controller/volume_controller.dart';
import 'package:rein_player/features/player_frame/controller/window_actions_controller.dart';
import 'package:rein_player/features/playlist/controller/album_content_controller.dart';
import 'package:rein_player/features/playlist/controller/playlist_controller.dart';
import 'package:rein_player/features/settings/controller/keyboard_preferences_controller.dart';

class KeyboardController extends GetxController {
  static KeyboardController get to => Get.find();

  void handleKey(KeyEvent event) async {
    if (event is KeyDownEvent) {
      final isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
      final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;
      final currentKey = event.logicalKey;

      // Get the keyboard preferences controller
      final keyPrefs = KeyboardPreferencesController.to;

      // Check each action and its assigned key
      final keyBindings = keyPrefs.keyBindings;

      // Play/Pause
      if (currentKey == keyBindings['play_pause']) {
        ControlsController.to.pauseOrPlay();
        return;
      }

      // Fullscreen
      if (currentKey == keyBindings['toggle_maximize_window'] &&
          !WindowActionsController.to.isFullScreenMode.value) {
        WindowActionsController.to.toggleWindowSize();
        return;
      }

      // Seek operations (with modifier key support)
      if (currentKey == keyBindings['seek_backward'] ||
          currentKey == keyBindings['big_seek_backward']) {
        if (isShiftPressed && currentKey == keyBindings['big_seek_backward']) {
          await ControlsController.to.bigSeekBackward();
        } else if (!isShiftPressed &&
            currentKey == keyBindings['seek_backward']) {
          await ControlsController.to.seekBackward();
        }
        return;
      }

      if (currentKey == keyBindings['seek_forward'] ||
          currentKey == keyBindings['big_seek_forward']) {
        if (isShiftPressed && currentKey == keyBindings['big_seek_forward']) {
          await ControlsController.to.bigSeekForward();
        } else if (!isShiftPressed &&
            currentKey == keyBindings['seek_forward']) {
          await ControlsController.to.seekForward();
        }
        return;
      }

      // Volume controls
      if (currentKey == keyBindings['volume_up']) {
        final currentVolume = VolumeController.to.currentVolume.value;
        final volumeToSet = currentVolume + 0.1;
        if (volumeToSet > 1) {
          VolumeController.to.updateVolume(1);
        } else {
          VolumeController.to.updateVolume(volumeToSet);
        }
        return;
      }

      if (currentKey == keyBindings['volume_down']) {
        final currentVolume = VolumeController.to.currentVolume.value;
        final volumeToSet = currentVolume - 0.1;
        if (volumeToSet < 0) {
          VolumeController.to.updateVolume(0);
        } else {
          VolumeController.to.updateVolume(volumeToSet);
        }
        return;
      }

      // Toggle mute
      if (currentKey == keyBindings['toggle_mute']) {
        VolumeController.to.toggleVolumeMuteState();
        return;
      }

      // Toggle subtitle
      if (currentKey == keyBindings['toggle_subtitle']) {
        SubtitleController.to.toggleSubtitle();
        return;
      }

      // Exit fullscreen
      if (currentKey == keyBindings['toggle_fullscreen']) {
        WindowActionsController.to.toggleFullScreenWindow();
        return;
      }

      // Toggle playlist (with Ctrl modifier)
      if (currentKey == keyBindings['toggle_playlist'] && isCtrlPressed) {
        PlaylistController.to.togglePlaylistWindow();
        return;
      }

      // Toggle developer log (with Ctrl modifier)
      if (currentKey == keyBindings['toggle_developer_log'] && isCtrlPressed) {
        DeveloperLogController.to.toggleVisibility();
        return;
      }

      // Playback speed controls
      if (currentKey == keyBindings['decrease_speed']) {
        PlaybackSpeedController.to.decreaseSpeed();
        return;
      }

      if (currentKey == keyBindings['increase_speed']) {
        PlaybackSpeedController.to.increaseSpeed();
        return;
      }

      // Playlist navigation
      if (currentKey == keyBindings['next_track']) {
        await AlbumContentController.to.goNextItemInPlaylist();
        return;
      }

      if (currentKey == keyBindings['previous_track']) {
        AlbumContentController.to.goPreviousItemInPlaylist();
        return;
      }

      // Delete current item and skip to next (with Shift modifier)
      if (currentKey == keyBindings['delete_and_skip'] && isShiftPressed) {
        final success =
            await AlbumContentController.to.deleteCurrentItemAndSkip();
        if (success) {
          RpSnackbar.success(
            title: 'Deleted',
            message: 'File deleted and skipped to next',
          );
        } else {
          RpSnackbar.error(message: 'Failed to delete file');
        }
        return;
      }
    }
  }
}
