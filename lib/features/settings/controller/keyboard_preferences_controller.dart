import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rein_player/common/widgets/rp_snackbar.dart';
import 'package:rein_player/utils/constants/rp_keys.dart';
import 'package:rein_player/utils/local_storage/rp_local_storage.dart';

class KeyboardPreferencesController extends GetxController {
  static KeyboardPreferencesController get to => Get.find();

  final storage = RpLocalStorage();

  final RxMap<String, LogicalKeyboardKey> keyBindings =
      <String, LogicalKeyboardKey>{}.obs;

  final RxBool shortcutsEnabled = true.obs;

  // Default keyboard bindings
  static const Map<String, LogicalKeyboardKey> defaultBindings = {
    'play_pause': LogicalKeyboardKey.space,
    'toggle_fullscreen': LogicalKeyboardKey.escape,
    'toggle_maximize_window': LogicalKeyboardKey.enter,
    'seek_backward': LogicalKeyboardKey.arrowLeft,
    'seek_forward': LogicalKeyboardKey.arrowRight,
    'big_seek_backward': LogicalKeyboardKey.arrowLeft, // With Shift
    'big_seek_forward': LogicalKeyboardKey.arrowRight, // With Shift
    'volume_up': LogicalKeyboardKey.arrowUp,
    'volume_down': LogicalKeyboardKey.arrowDown,
    'toggle_mute': LogicalKeyboardKey.keyM,
    'toggle_subtitle': LogicalKeyboardKey.keyH,
    'toggle_playlist': LogicalKeyboardKey.keyB, // With Ctrl
    'toggle_developer_log': LogicalKeyboardKey.keyD, // With Ctrl
    'toggle_keyboard_bindings': LogicalKeyboardKey.keyK, // With Ctrl
    'decrease_speed': LogicalKeyboardKey.keyX,
    'increase_speed': LogicalKeyboardKey.keyC,
    'next_track': LogicalKeyboardKey.pageDown,
    'previous_track': LogicalKeyboardKey.pageUp,
    'delete_and_skip': LogicalKeyboardKey.delete, // With Shift
    'shuffle_playlist': LogicalKeyboardKey.keyS,
    'add_bookmark': LogicalKeyboardKey.keyB, // With Ctrl
    'next_bookmark': LogicalKeyboardKey.keyB,
    'previous_bookmark': LogicalKeyboardKey.keyB, // With Shift
    'toggle_bookmark_list': LogicalKeyboardKey.keyB, // With Ctrl+Shift
    'add_ab_loop_segment': LogicalKeyboardKey.keyL, // With Ctrl
    'toggle_ab_loop_overlay': LogicalKeyboardKey.keyL,
    'toggle_ab_loop_playback': LogicalKeyboardKey.keyL, // With Ctrl+Shift
    'previous_ab_loop_segment': LogicalKeyboardKey.bracketLeft,
    'next_ab_loop_segment': LogicalKeyboardKey.bracketRight,
    'export_ab_loops': LogicalKeyboardKey.keyE, // With Ctrl+Shift
  };

  // Action descriptions for UI
  static const Map<String, String> actionDescriptions = {
    'play_pause': 'Play/Pause',
    'toggle_fullscreen': 'Enter Fullscreen',
    'toggle_maximize_window': 'Toggle Maximize Window',
    'seek_backward': 'Seek Backward',
    'seek_forward': 'Seek Forward',
    'big_seek_backward': 'Big Seek Backward',
    'big_seek_forward': 'Big Seek Forward',
    'volume_up': 'Volume Up',
    'volume_down': 'Volume Down',
    'toggle_mute': 'Toggle Mute',
    'toggle_subtitle': 'Toggle Subtitles',
    'exit_fullscreen': 'Exit Fullscreen',
    'toggle_playlist': 'Toggle Playlist',
    'toggle_developer_log': 'Toggle Developer Log',
    'toggle_keyboard_bindings': 'Toggle Keyboard Bindings',
    'decrease_speed': 'Decrease Playback Speed',
    'increase_speed': 'Increase Playback Speed',
    'next_track': 'Next Track',
    'previous_track': 'Previous Track',
    'delete_and_skip': 'Delete playlist Item and Skip to Next',
    'shuffle_playlist': 'Shuffle Playlist',
    'add_bookmark': 'Add Bookmark',
    'next_bookmark': 'Jump to Next Bookmark',
    'previous_bookmark': 'Jump to Previous Bookmark',
    'toggle_bookmark_list': 'Toggle Bookmark List',
    'add_ab_loop_segment': 'Add A-B Loop Segment',
    'toggle_ab_loop_overlay': 'Toggle A-B Loop Overlay',
    'toggle_ab_loop_playback': 'Start/Stop A-B Loop Playback',
    'previous_ab_loop_segment': 'Jump to Previous A-B Loop Segment',
    'next_ab_loop_segment': 'Jump to Next A-B Loop Segment',
    'export_ab_loops': 'Export A-B Loops to PBF File',
  };

  @override
  void onInit() {
    super.onInit();
    loadKeyBindings();
  }

  Future<void> loadKeyBindings() async {
    try {
      final savedBindings =
          storage.readData<Map>(RpKeysConstants.keyboardBindingsKey);

      // Load shortcuts enabled state
      final savedEnabled = storage.readData<bool>(RpKeysConstants.keyboardShortcutsEnabledKey);
      shortcutsEnabled.value = savedEnabled ?? true;

      if (savedBindings != null) {
        // Convert saved data back to LogicalKeyboardKey objects
        for (String action in defaultBindings.keys) {
          final keyCode = savedBindings[action];
          if (keyCode != null) {
            final key = LogicalKeyboardKey.findKeyByKeyId(keyCode);
            if (key != null) {
              keyBindings[action] = key;
            } else {
              keyBindings[action] = defaultBindings[action]!;
            }
          } else {
            keyBindings[action] = defaultBindings[action]!;
          }
        }
      } else {
        keyBindings.addAll(defaultBindings);
      }
      update();
    } catch (e) {
      keyBindings.addAll(defaultBindings);
      update();
    }
  }

  Future<void> saveKeyBindings() async {
    try {
      final Map<String, int> saveData = {};
      for (String action in keyBindings.keys) {
        saveData[action] = keyBindings[action]!.keyId;
      }
      await storage.saveData(RpKeysConstants.keyboardBindingsKey, saveData);
    } catch (e) {
      // do nothing
    }
  }

  Future<void> updateKeyBinding(String action, LogicalKeyboardKey key) async {
    final existingAction = getActionForKey(key);
    if (existingAction != null && existingAction != action) {
      // Swap the keys
      final oldKey = keyBindings[action];
      if (oldKey != null) {
        keyBindings[action] = key;
        keyBindings[existingAction] = oldKey;

        update();

        RpSnackbar.info(
          title: 'Key Binding Updated',
          message:
              'Swapped keys for "${actionDescriptions[action]}" and "${actionDescriptions[existingAction]}"',
        );
      }
    } else {
      keyBindings[action] = key;

      update();

      RpSnackbar.success(
        title: 'Key Binding Updated',
        message:
            '${actionDescriptions[action]} is now assigned to ${getKeyDisplayName(key)}',
      );
    }

    await saveKeyBindings();
  }

  String? getActionForKey(LogicalKeyboardKey key) {
    for (String action in keyBindings.keys) {
      if (keyBindings[action] == key) {
        return action;
      }
    }
    return null;
  }

  Future<void> resetToDefaults() async {
    keyBindings.clear();
    keyBindings.addAll(defaultBindings);

    update();

    await saveKeyBindings();

    RpSnackbar.success(
      title: 'Reset Complete',
      message: 'Keyboard bindings have been reset to defaults',
    );
  }

  String getKeyDisplayName(LogicalKeyboardKey key) {
    // Handle special keys
    if (key == LogicalKeyboardKey.space) return 'Space';
    if (key == LogicalKeyboardKey.enter) return 'Enter';
    if (key == LogicalKeyboardKey.escape) return 'Escape';
    if (key == LogicalKeyboardKey.arrowUp) return 'Arrow Up';
    if (key == LogicalKeyboardKey.arrowDown) return 'Arrow Down';
    if (key == LogicalKeyboardKey.arrowLeft) return 'Arrow Left';
    if (key == LogicalKeyboardKey.arrowRight) return 'Arrow Right';
    if (key == LogicalKeyboardKey.pageUp) return 'Page Up';
    if (key == LogicalKeyboardKey.pageDown) return 'Page Down';

    // Handle bracket keys
    if (key == LogicalKeyboardKey.bracketLeft) return '[';
    if (key == LogicalKeyboardKey.bracketRight) return ']';
    if (key == LogicalKeyboardKey.delete) return 'Delete';

    // Handle letter keys
    if (key.keyLabel.length == 1) {
      return key.keyLabel.toUpperCase();
    }

    return key.keyLabel;
  }

  LogicalKeyboardKey? getKeyForAction(String action) {
    return keyBindings[action];
  }

  Future<void> toggleShortcuts(bool enabled) async {
    shortcutsEnabled.value = enabled;
    await storage.saveData(RpKeysConstants.keyboardShortcutsEnabledKey, enabled);
    update();
  }
}
