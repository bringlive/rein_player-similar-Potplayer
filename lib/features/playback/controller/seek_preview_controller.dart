import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rein_player/features/playback/controller/video_and_controls_controller.dart';
import 'package:rein_player/features/playback/controller/controls_controller.dart';

class SeekPreviewController extends GetxController {
  static SeekPreviewController get to => Get.find();

  Player? _previewPlayer;

  final RxBool isPreviewVisible = false.obs;
  final Rx<Offset> previewPosition = Offset.zero.obs;
  final RxDouble previewProgress = 0.0.obs;
  final Rx<Duration?> previewTimestamp = Rx<Duration?>(null);

  VideoController? _previewVideoController;
  VideoController? get previewVideoController => _previewVideoController;

  @override
  void onInit() {
    super.onInit();
    _initializePreviewPlayer();
  }

  Future<void> _initializePreviewPlayer() async {
    try {
      _previewPlayer = Player();

      await _previewPlayer!.setVolume(0);
      await _previewPlayer!.setPlaylistMode(PlaylistMode.none);

      if (_previewPlayer!.platform is NativePlayer) {
        try {
          // Optimize for preview - use hardware decode for better performance
          await (_previewPlayer!.platform as dynamic).setProperty(
            'hwdec',
            'auto',
          );

          // Enable fast seeking for preview
          await (_previewPlayer!.platform as dynamic).setProperty(
            'hr-seek',
            'yes',
          );
        } catch (e) {
          //do nothing
        }
      }

      _previewVideoController = VideoController(_previewPlayer!);
    } catch (e) {
      //do nothing
    }
  }

  void showPreview({
    required Offset position,
    required double progress,
    required RenderBox progressBarBox,
  }) async {
    if (_previewPlayer == null) return;

    final currentVideo = VideoAndControlController.to.currentVideo.value;
    if (currentVideo == null) return;

    final duration = ControlsController.to.videoDuration.value;
    if (duration == null) return;

    final timestamp =
        Duration(seconds: (progress * duration.inSeconds).toInt());
    previewTimestamp.value = timestamp;
    previewProgress.value = progress;

    final screenPosition = progressBarBox.localToGlobal(position);
    previewPosition.value = screenPosition;

    if (_previewPlayer!.state.playlist.medias.isEmpty ||
        _previewPlayer!.state.playlist.medias.first.uri !=
            currentVideo.location) {
      await _loadPreviewVideo(currentVideo.location);
    }

    await _previewPlayer!.seek(timestamp);

    isPreviewVisible.value = true;
  }

  Future<void> _loadPreviewVideo(String videoPath) async {
    if (_previewPlayer == null) return;

    try {
      await _previewPlayer!.open(Media(videoPath), play: false);
      await _previewPlayer!.pause();
      await _previewPlayer!.setVolume(0);
    } catch (e) {
      hidePreview();
    }
  }

  void updatePreviewPosition({
    required Offset position,
    required double progress,
    required RenderBox progressBarBox,
  }) {
    if (!isPreviewVisible.value) {
      showPreview(
        position: position,
        progress: progress,
        progressBarBox: progressBarBox,
      );
    } else {
      final duration = ControlsController.to.videoDuration.value;
      if (duration == null) return;

      final timestamp =
          Duration(seconds: (progress * duration.inSeconds).toInt());
      previewTimestamp.value = timestamp;
      previewProgress.value = progress;

      final screenPosition = progressBarBox.localToGlobal(position);
      previewPosition.value = screenPosition;

      _previewPlayer?.seek(timestamp);
    }
  }

  void hidePreview() {
    isPreviewVisible.value = false;
    previewTimestamp.value = null;
  }

  String getFormattedPreviewTime() {
    if (previewTimestamp.value == null) return "00:00";

    final duration = previewTimestamp.value!;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  void onClose() {
    _previewPlayer?.dispose();
    _previewPlayer = null;
    _previewVideoController = null;
    super.onClose();
  }
}
