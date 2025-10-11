import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class RpDeviceUtils {
  RpDeviceUtils._();

  static bool isLandscapeOrientation(BuildContext context) {
    final viewInsects = View.of(context).viewInsets;
    return viewInsects.bottom == 0;
  }

  static bool isPortraitOrientation(BuildContext context) {
    final viewInsects = View.of(context).viewInsets;
    return viewInsects.bottom != 0;
  }

  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
        enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<Size> getWindowFrameSize() async {
    return await windowManager.getSize();
  }

  static Future<void> setWindowFrameSize(Size size) async {
    await windowManager.setSize(size);
  }

  static bool isWindows() {
    return Platform.isWindows;
  }

  static bool isLinux() {
    return Platform.isLinux;
  }

  static bool isMacOS() {
    return Platform.isMacOS;
  }
}
