import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';

enum RpSnackbarType { success, error, info, warning }

class RpSnackbar {
  static void show({
    required String title,
    required String message,
    RpSnackbarType type = RpSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case RpSnackbarType.success:
        backgroundColor = RpColors.accent;
        textColor = Colors.black;
        icon = Icons.check_circle;
      case RpSnackbarType.error:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        icon = Icons.error;
      case RpSnackbarType.warning:
        backgroundColor = Colors.orange;
        textColor = Colors.black;
        icon = Icons.warning;
      case RpSnackbarType.info:
        backgroundColor = RpColors.gray_900;
        textColor = Colors.white;
        icon = Icons.info;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor.withValues(alpha: 0.95),
      colorText: textColor,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(icon, color: textColor),
      shouldIconPulse: false,
      maxWidth: 400,
    );
  }

  static void success({
    required String message,
    String title = 'Success',
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      title: title,
      message: message,
      type: RpSnackbarType.success,
      duration: duration,
    );
  }

  static void error({
    required String message,
    String title = 'Error',
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: RpSnackbarType.error,
      duration: duration,
    );
  }

  static void info({
    required String message,
    String title = 'Info',
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      title: title,
      message: message,
      type: RpSnackbarType.info,
      duration: duration,
    );
  }

  static void warning({
    required String message,
    String title = 'Warning',
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: RpSnackbarType.warning,
      duration: duration,
    );
  }

  static void copied({String item = 'Item'}) {
    success(
      title: 'Copied',
      message: '$item copied to clipboard',
      duration: const Duration(seconds: 2),
    );
  }
}
