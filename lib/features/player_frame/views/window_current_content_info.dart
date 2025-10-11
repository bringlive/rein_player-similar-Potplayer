import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rein_player/features/playback/controller/video_and_controls_controller.dart';
import 'package:rein_player/features/player_frame/controller/window_controller.dart';
import 'package:rein_player/features/playlist/controller/album_content_controller.dart';
import 'package:rein_player/utils/device/rp_device_utils.dart';

import '../../../common/widgets/rp_vertical_divider.dart';
import '../../../utils/constants/rp_colors.dart';
import '../controller/window_info_controller.dart';

class RpWindowCurrentContentInfo extends StatelessWidget {
  const RpWindowCurrentContentInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Obx(() {
        return VideoAndControlController.to.currentVideo.value == null
            ? const SizedBox.shrink()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  /// file type
                  Text(
                    WindowInfoController.to.getFileType(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Container(
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: const RpVerticalDivider(
                        backgroundColor: RpColors.black_500),
                  ),

                  /// title
                  if (!RpDeviceUtils.isWindows())
                    Obx(() {
                      final width =
                          WindowController.to.currentWindowSize.value.width;
                      return SizedBox(
                        width: width > 400 ? width - 400 : width,
                        child: Text(
                          "${AlbumContentController.to.getPlaylistPlayingProgress()} ${WindowInfoController.to.getCurrentVideoTitle()}",
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }),

                  if (RpDeviceUtils.isWindows())
                    Text(
                      "${AlbumContentController.to.getPlaylistPlayingProgress()} ${WindowInfoController.to.getCurrentVideoTitle()}",
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                ],
              );
      }),
    );
  }
}
