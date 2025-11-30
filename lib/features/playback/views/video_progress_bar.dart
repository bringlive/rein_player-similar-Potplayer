import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rein_player/core/video_player.dart';

import '../../../common/widgets/rp_rounded_indicator.dart';
import '../../../utils/constants/rp_colors.dart';
import '../controller/controls_controller.dart';
import '../controller/seek_preview_controller.dart';

class RpVideoProgressBar extends StatelessWidget {
  RpVideoProgressBar({super.key});

  final GlobalKey progressBarKey = GlobalKey();
  final player = VideoPlayer.getInstance.player;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final box =
            progressBarKey.currentContext?.findRenderObject() as RenderBox?;
        if (box == null) return;

        final localPosition = event.localPosition;
        final totalWidth = box.size.width;
        final progress = (localPosition.dx / totalWidth).clamp(0.0, 1.0);

        SeekPreviewController.to.updatePreviewPosition(
          position: localPosition,
          progress: progress,
          progressBarBox: box,
        );
      },
      onExit: (_) {
        SeekPreviewController.to.hidePreview();
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          RenderBox box =
              progressBarKey.currentContext!.findRenderObject() as RenderBox;
          ControlsController.to.videoOnPanUpdate(box, details);
          SeekPreviewController.to.hidePreview();
        },
        onPanEnd: (details) async {
          await ControlsController.to.videoOnPanEnd();
        },
        onTapDown: (details) async {
          RenderBox box =
              progressBarKey.currentContext!.findRenderObject() as RenderBox;
          await ControlsController.to.videoOnTapDown(box, details);
          SeekPreviewController.to.hidePreview();
        },
        child: Obx(
          () => Container(
            color: RpColors.gray_900,
            height: double.infinity,
            child: Stack(
              key: progressBarKey,
              alignment: Alignment.centerLeft,
              children: [
                // Background line
                Container(
                  height: 1,
                  width: double.infinity,
                  color: RpColors.black_600,
                ),
                FractionallySizedBox(
                  widthFactor: ControlsController.to.currentVideoProgress.value,
                  child: Container(
                    height: 2,
                    color: RpColors.accent,
                  ),
                ),
                Align(
                  alignment: Alignment(
                    ControlsController.to.currentVideoProgress.value * 2 - 1,
                    0,
                  ),
                  child: const RpRoundedIndicator(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
