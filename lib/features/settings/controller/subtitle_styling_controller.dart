import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rein_player/features/settings/models/subtitle_settings.dart';
import 'package:rein_player/utils/constants/rp_keys.dart';
import 'package:rein_player/utils/constants/subtitle_constants.dart';
import 'package:rein_player/utils/local_storage/rp_local_storage.dart';

class SubtitleStylingController extends GetxController {
  static SubtitleStylingController get to => Get.find();

  final storage = RpLocalStorage();

  final Rx<SubtitleSettings> settings = SubtitleSettings().obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// load subtitle settings from storage
  Future<void> _loadSettings() async {
    try {
      final data = await storage.readData(RpKeysConstants.subtitleSettingsKey);
      if (data != null) {
        settings.value = SubtitleSettings.fromJson(data);
      }
    } catch (e) {
      settings.value = SubtitleSettings.defaults();
    }
  }

  /// save subtitle settings to storage
  Future<void> _saveSettings() async {
    await storage.saveData(
      RpKeysConstants.subtitleSettingsKey,
      settings.value.toJson(),
    );
  }

  /// update font family
  Future<void> updateFontFamily(String fontFamily) async {
    settings.value = settings.value.copyWith(fontFamily: fontFamily);
    await _saveSettings();
  }

  /// update font size
  Future<void> updateFontSize(double fontSize) async {
    final clampedSize = fontSize.clamp(
      SubtitleConstants.minFontSize,
      SubtitleConstants.maxFontSize,
    );
    settings.value = settings.value.copyWith(fontSize: clampedSize);
    await _saveSettings();
  }

  /// Move subtitle up
  Future<void> moveUp() async {
    final newPosition = (settings.value.verticalPosition -
            SubtitleConstants.positionStep)
        .clamp(-SubtitleConstants.maxPosition, SubtitleConstants.maxPosition);
    settings.value = settings.value.copyWith(verticalPosition: newPosition);
    await _saveSettings();
  }

  /// Move subtitle down
  Future<void> moveDown() async {
    final newPosition = (settings.value.verticalPosition +
            SubtitleConstants.positionStep)
        .clamp(-SubtitleConstants.maxPosition, SubtitleConstants.maxPosition);
    settings.value = settings.value.copyWith(verticalPosition: newPosition);
    await _saveSettings();
  }

  /// Move subtitle left
  Future<void> moveLeft() async {
    final newPosition = (settings.value.horizontalPosition -
            SubtitleConstants.positionStep)
        .clamp(-SubtitleConstants.maxPosition, SubtitleConstants.maxPosition);
    settings.value = settings.value.copyWith(horizontalPosition: newPosition);
    await _saveSettings();
  }

  /// Move subtitle right
  Future<void> moveRight() async {
    final newPosition = (settings.value.horizontalPosition +
            SubtitleConstants.positionStep)
        .clamp(-SubtitleConstants.maxPosition, SubtitleConstants.maxPosition);
    settings.value = settings.value.copyWith(horizontalPosition: newPosition);
    await _saveSettings();
  }

  /// Update text color
  Future<void> updateTextColor(Color color) async {
    settings.value = settings.value.copyWith(textColor: color);
    await _saveSettings();
  }

  /// Update background color
  Future<void> updateBackgroundColor(Color color) async {
    settings.value = settings.value.copyWith(backgroundColor: color);
    await _saveSettings();
  }

  /// Update outline color
  Future<void> updateOutlineColor(Color color) async {
    settings.value = settings.value.copyWith(outlineColor: color);
    await _saveSettings();
  }

  /// Update outline width
  Future<void> updateOutlineWidth(double width) async {
    final clampedWidth = width.clamp(0.0, SubtitleConstants.maxOutlineWidth);
    settings.value = settings.value.copyWith(outlineWidth: clampedWidth);
    await _saveSettings();
  }

  /// Update text alignment
  Future<void> updateTextAlign(TextAlign align) async {
    settings.value = settings.value.copyWith(textAlign: align);
    await _saveSettings();
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    settings.value = SubtitleSettings.defaults();
    await _saveSettings();
  }

  /// Get EdgeInsets for subtitle positioning
  EdgeInsets getSubtitlePadding() {
    // Ensure all padding values are non-negative to prevent layout errors
    final bottomPadding =
        (50.0 - settings.value.verticalPosition).clamp(0.0, double.infinity);
    final leftPadding = settings.value.horizontalPosition > 0
        ? settings.value.horizontalPosition.clamp(0.0, double.infinity)
        : 0.0;
    final rightPadding = settings.value.horizontalPosition < 0
        ? (-settings.value.horizontalPosition).clamp(0.0, double.infinity)
        : 0.0;

    return EdgeInsets.only(
      bottom: bottomPadding,
      left: leftPadding,
      right: rightPadding,
    );
  }

  /// Get TextStyle for subtitles
  TextStyle getSubtitleTextStyle() {
    return TextStyle(
      fontFamily: settings.value.fontFamily,
      fontSize: settings.value.fontSize,
      color: settings.value.textColor,
      backgroundColor: settings.value.backgroundColor,
      shadows: [
        Shadow(
          offset:
              Offset(settings.value.outlineWidth, settings.value.outlineWidth),
          color: settings.value.outlineColor,
          blurRadius: settings.value.outlineWidth,
        ),
        Shadow(
          offset: Offset(
              -settings.value.outlineWidth, -settings.value.outlineWidth),
          color: settings.value.outlineColor,
          blurRadius: settings.value.outlineWidth,
        ),
        Shadow(
          offset:
              Offset(settings.value.outlineWidth, -settings.value.outlineWidth),
          color: settings.value.outlineColor,
          blurRadius: settings.value.outlineWidth,
        ),
        Shadow(
          offset:
              Offset(-settings.value.outlineWidth, settings.value.outlineWidth),
          color: settings.value.outlineColor,
          blurRadius: settings.value.outlineWidth,
        ),
      ],
    );
  }
}
