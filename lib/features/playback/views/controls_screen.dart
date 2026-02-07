import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rein_player/utils/constants/rp_app_icons.dart';
import 'package:rein_player/features/playback/controller/controls_controller.dart';
import 'package:rein_player/features/playback/views/video_action_controls.dart';
import 'package:rein_player/features/player_frame/controller/navigation_context_controller.dart';
import 'package:rein_player/features/playlist/controller/playlist_controller.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';

import 'video_progress_and_volume.dart';

class RpControls extends StatelessWidget {
  const RpControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3, left: 3, bottom: 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Duration and volume controls
          const RpVideoProgressAndVolume(),
          const SizedBox(height: 2),

          /// Action controls
          Container(
            width: double.infinity,
            color: RpColors.gray_900,
            height: 30,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                /// video action controls
                const RpVideoActionControls(),

                /// type and time counter
                const RpVideoTypeAndTimeCounter(),
                const Spacer(),

                /// toggle playlist
                GestureDetector(
                  onTap: () {
                    PlaylistController.to.togglePlaylistWindow();
                    if (PlaylistController.to.isPlaylistWindowOpened.value) {
                      NavigationContextController.to.switchToPlaylist();
                    }
                  },
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        left: BorderSide(width: 1, color: RpColors.black),
                      ),
                    ),
                    child: Obx(() {
                      if (PlaylistController.to.isPlaylistWindowOpened.value) {
                        return SvgPicture.asset(RpAppIcons.playlistBurgerIcon);
                      }
                      return SvgPicture.asset(
                        RpAppIcons.playlistBurgerIcon,
                        colorFilter: const ColorFilter.mode(
                            RpColors.white, BlendMode.srcIn),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RpVideoTypeAndTimeCounter extends StatelessWidget {
  const RpVideoTypeAndTimeCounter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Text(ControlsController.to.getFormattedTimeWatched(),
              style: Theme.of(context).textTheme.bodySmall)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Text(
              "/",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: RpColors.black_500),
            ),
          ),
          Obx(
            () => Text(
              ControlsController.to.getFormattedTotalDuration(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
