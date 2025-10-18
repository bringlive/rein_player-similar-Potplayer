import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rein_player/features/playback/controller/seek_preview_controller.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';

class SeekPreviewOverlay extends StatelessWidget {
  const SeekPreviewOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = SeekPreviewController.to;

      if (!controller.isPreviewVisible.value ||
          controller.previewVideoController == null) {
        return const SizedBox.shrink();
      }

      const double previewWidth = 200;
      const double previewHeight = 112;
      const double padding = 8.0;

      final cursorX = controller.previewPosition.value.dx;
      final cursorY = controller.previewPosition.value.dy;

      final screenWidth = MediaQuery.of(context).size.width;
      double left = (cursorX - previewWidth / 2)
          .clamp(padding, screenWidth - previewWidth - padding);

      double top = cursorY - previewHeight - 60;

      return Positioned(
        left: left,
        top: top,
        child: _PreviewCard(
          controller: controller,
          width: previewWidth,
          height: previewHeight,
        ),
      );
    });
  }
}

class _PreviewCard extends StatelessWidget {
  final SeekPreviewController controller;
  final double width;
  final double height;

  const _PreviewCard({
    required this.controller,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: RpColors.gray_900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: RpColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Video preview
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            child: Container(
              width: width,
              height: height,
              color: Colors.black,
              child: Video(
                controller: controller.previewVideoController!,
                controls: null,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Timestamp
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: const BoxDecoration(
              color: RpColors.gray_900,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            child: Text(
              controller.getFormattedPreviewTime(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
