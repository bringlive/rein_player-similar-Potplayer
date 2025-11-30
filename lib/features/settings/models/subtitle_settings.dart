import 'package:flutter/material.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';
import 'package:rein_player/utils/constants/rp_keys.dart';

/// Model for subtitle customization settings
class SubtitleSettings {
  /// Font family for subtitles
  String fontFamily;

  /// Font size in points
  double fontSize;

  /// Vertical position offset (negative = up, positive = down)
  double verticalPosition;

  /// Horizontal position offset (negative = left, positive = right)
  double horizontalPosition;

  /// Text color
  Color textColor;

  /// Background color
  Color backgroundColor;

  /// Text outline color
  Color outlineColor;

  /// Outline width
  double outlineWidth;

  /// Text alignment
  TextAlign textAlign;

  SubtitleSettings({
    this.fontFamily = 'Segoe UI',
    this.fontSize = 20.0,
    this.verticalPosition = 0.0,
    this.horizontalPosition = 0.0,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0x99000000),
    this.outlineColor = Colors.black,
    this.outlineWidth = 1.5,
    this.textAlign = TextAlign.center,
  });

  /// Create from JSON
  factory SubtitleSettings.fromJson(Map<String, dynamic> json) {
    return SubtitleSettings(
      fontFamily:
          json[RpKeysConstants.subtitleFontFamilyKey] as String? ?? 'Segoe UI',
      fontSize:
          (json[RpKeysConstants.subtitleFontSizeKey] as num?)?.toDouble() ??
              20.0,
      verticalPosition:
          (json[RpKeysConstants.subtitleVerticalPositionKey] as num?)
                  ?.toDouble() ??
              0.0,
      horizontalPosition:
          (json[RpKeysConstants.subtitleHorizontalPositionKey] as num?)
                  ?.toDouble() ??
              0.0,
      textColor: Color(json[RpKeysConstants.subtitleTextColorKey] as int? ??
          RpColors.white.value.toInt()),
      backgroundColor: Color(
          json[RpKeysConstants.subtitleBackgroundColorKey] as int? ??
              0x99000000),
      outlineColor: Color(
          json[RpKeysConstants.subtitleOutlineColorKey] as int? ?? 0xFF000000),
      outlineWidth:
          (json[RpKeysConstants.subtitleOutlineWidthKey] as num?)?.toDouble() ??
              1.5,
      textAlign: TextAlign
          .values[json[RpKeysConstants.subtitleTextAlignKey] as int? ?? 1],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      RpKeysConstants.subtitleFontFamilyKey: fontFamily,
      RpKeysConstants.subtitleFontSizeKey: fontSize,
      RpKeysConstants.subtitleVerticalPositionKey: verticalPosition,
      RpKeysConstants.subtitleHorizontalPositionKey: horizontalPosition,
      RpKeysConstants.subtitleTextColorKey: textColor.value,
      RpKeysConstants.subtitleBackgroundColorKey: backgroundColor.value,
      RpKeysConstants.subtitleOutlineColorKey: outlineColor.value,
      RpKeysConstants.subtitleOutlineWidthKey: outlineWidth,
      RpKeysConstants.subtitleTextAlignKey: textAlign.index,
    };
  }

  /// Create a copy with modifications
  SubtitleSettings copyWith({
    String? fontFamily,
    double? fontSize,
    double? verticalPosition,
    double? horizontalPosition,
    Color? textColor,
    Color? backgroundColor,
    Color? outlineColor,
    double? outlineWidth,
    TextAlign? textAlign,
  }) {
    return SubtitleSettings(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      verticalPosition: verticalPosition ?? this.verticalPosition,
      horizontalPosition: horizontalPosition ?? this.horizontalPosition,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      outlineColor: outlineColor ?? this.outlineColor,
      outlineWidth: outlineWidth ?? this.outlineWidth,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  /// Reset to defaults
  static SubtitleSettings defaults() {
    return SubtitleSettings();
  }
}
