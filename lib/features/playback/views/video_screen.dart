import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rein_player/features/playback/controller/video_and_controls_controller.dart';
import 'package:rein_player/features/playback/controller/volume_controller.dart';
import 'package:rein_player/features/player_frame/controller/window_actions_controller.dart';
import 'package:rein_player/features/settings/controller/menu_controller.dart';
import 'package:rein_player/features/settings/controller/subtitle_styling_controller.dart';
import 'package:rein_player/features/playback/views/playback_speed_overlay.dart';
import 'package:rein_player/features/playback/views/bookmark_overlay.dart';
import 'package:rein_player/features/settings/views/menu/menu_items.dart';
import 'package:rein_player/listeners/scroll_detector.dart';

import 'no_media_placeholder.dart';

class RpVideoScreen extends StatelessWidget {
  const RpVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoController = Get.put(VideoAndControlController());

    return Obx(() {
      return ContextMenuRegion(
        contextMenu: createContextMenu(),
        child: MouseRegion(
          onHover: (_) => MainMenuController.to.hideMenu,
          child: ScrollDetector(
            onPointerScroll: VolumeController.to.onScrollUpdateVolume,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 9.0 / 16.0,
                child: Stack(
                  children: [
                    /// video
                    GestureDetector(
                      onDoubleTap: WindowActionsController.to.toggleWindowSize,
                      onTertiaryTapUp: (details) {
                        if (details.kind == PointerDeviceKind.mouse) {
                          WindowActionsController.to.toggleWindowSize();
                        }
                      },
                      child: Obx(() {
                        if (VideoAndControlController
                            .to.currentVideoUrl.isEmpty) {
                          return const RpNoMediaPlaceholder();
                        }

                        // Get subtitle styling controller
                        final subtitleController = SubtitleStylingController.to;

                        return Obx(() => Video(
                              key: ValueKey(
                                  VideoAndControlController.to.currentVideoUrl),
                              controller: videoController.videoPlayerController,
                              controls: NoVideoControls,
                              subtitleViewConfiguration:
                                  SubtitleViewConfiguration(
                                padding:
                                    subtitleController.getSubtitlePadding(),
                                style:
                                    subtitleController.getSubtitleTextStyle(),
                                textAlign:
                                    subtitleController.settings.value.textAlign,
                              ),
                            ));
                      }),
                    ),

                    /// playback speed overlay
                    const PlaybackSpeedOverlay(),

                    /// bookmark overlay
                    const BookmarkOverlay(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
