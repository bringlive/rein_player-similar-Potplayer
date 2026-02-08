import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:media_kit/media_kit.dart';
import 'package:rein_player/core/video_player.dart';
import 'package:window_manager/window_manager.dart';
import 'package:rein_player/utils/constants/rp_sizes.dart';
import 'package:rein_player/utils/constants/app_info.dart';
import 'package:rein_player/features/playback/controller/video_and_controls_controller.dart';
import 'package:rein_player/features/developer/controller/developer_log_controller.dart';

import 'app.dart';

void main(List<String> args) async {
  // Handle CLI flags before initializing Flutter
  if (args.isNotEmpty) {
    _handleCliFlags(args);
  }

  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await GetStorage.init();
  await windowManager.ensureInitialized();

  await VideoPlayer.getInstance.ensureInitialized();

  doWhenWindowReady(() {
    windowManager.setSize(RpSizes.initialAppWindowSize);
    windowManager.setMinimumSize(RpSizes.initialAppWindowSize);
    appWindow.alignment = Alignment.center;
    windowManager.show();
  });

  runApp(RpApp());

  // Wait for bindings to be initialized
  await Future.delayed(Duration.zero);

  // Set up file handler channel for macOS Finder file opening
  if (Platform.isMacOS) {
    const fileChannel = MethodChannel('com.reinplayer/file_handler');
    fileChannel.setMethodCallHandler((call) async {
      if (call.method == 'openFiles') {
        try {
          final List<String> filePaths = List<String>.from(call.arguments);
          DeveloperLogController.to
              .log("Received files from Finder: $filePaths");
          if (filePaths.isNotEmpty) {
            await VideoAndControlController.to.handleCommandLineArgs(filePaths);
          }
        } catch (e) {
          DeveloperLogController.to.log("Error handling files from Finder: $e");
        }
      }
    });
  }

  DeveloperLogController.to.log("arms $args");
  if (args.isNotEmpty) {
    await VideoAndControlController.to.handleCommandLineArgs(args);
  }
}

/// Handle CLI flags like --version and --help
void _handleCliFlags(List<String> args) {
  if (args.isEmpty) return;

  final arg = args.first.toLowerCase().trim();

  // Handle version flags
  if (arg == '--version' || arg == '-v') {
    // Write directly to stdout to avoid Flutter capturing it
    stdout.writeln('${AppInfo.appName} ${AppInfo.version}');
    stdout.writeln(AppInfo.shortDescription);
    stdout.writeln('');
    stdout.writeln('Repository: ${AppInfo.repository}');
    exit(0);
  }

  // Handle help flags
  if (arg == '--help' || arg == '-h') {
    _printHelp();
    exit(0);
  }
}

/// Print help information
void _printHelp() {
  stdout.writeln('${AppInfo.appName} - ${AppInfo.shortDescription}');
  stdout.writeln('');
  stdout.writeln('Usage: reinplayer [OPTIONS] [FILE]');
  stdout.writeln('');
  stdout.writeln('Options:');
  stdout.writeln('  --version, -v    Show version information and exit');
  stdout.writeln('  --help, -h       Show this help message and exit');
  stdout.writeln('');
  stdout.writeln('Arguments:');
  stdout.writeln('  FILE             Path to video file to play');
  stdout.writeln('                   Supports all FFmpeg-compatible formats');
  stdout.writeln('');
  stdout.writeln('Examples:');
  stdout.writeln('  reinplayer --version');
  stdout.writeln('  reinplayer --help');
  stdout.writeln('  reinplayer /path/to/video.mp4');
  stdout.writeln('  reinplayer ~/Videos/movie.mkv');
  stdout.writeln('');
  stdout.writeln('For more information, visit: ${AppInfo.repository}');
}
