import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rein_player/features/player_frame/controller/navigation_context_controller.dart';
import 'package:rein_player/features/playlist/controller/playlist_controller.dart';
import 'package:rein_player/features/playlist/views/video_collection_sources.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';

import 'album_content.dart';
import 'all_albums.dart';

class RpPlaylistSideBar extends StatelessWidget {
  const RpPlaylistSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          NavigationContextController.to.switchToPlaylist();
        },
        child: Container(
          decoration: const BoxDecoration(color: RpColors.gray_800),
          width: PlaylistController.to.playlistWindowWidth.value,
          height: double.infinity,
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              /// Browser and playlist selector
              RpVideoCollectionSources(),

              /// All playlist
              RpAllAlbums(),

              /// Current playlist files
              Expanded(child: AlbumContent())
            ],
          ),
        ),
      );
    });
  }
}
