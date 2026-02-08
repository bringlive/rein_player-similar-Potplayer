import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:media_kit/media_kit.dart';
import 'package:get/get.dart';
import 'package:rein_player/common/widgets/rp_snackbar.dart';
import 'package:rein_player/features/playback/controller/audio_track_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rein_player/features/playback/controller/ab_loop_controller.dart';
import 'package:rein_player/features/playback/controller/bookmark_controller.dart';
import 'package:rein_player/features/playback/controller/controls_controller.dart';
import 'package:rein_player/features/playback/controller/playlist_type_controller.dart';
import 'package:rein_player/features/playback/controller/subtitle_controller.dart';
import 'package:rein_player/features/playback/controller/video_and_controls_controller.dart';
import 'package:rein_player/features/player_frame/controller/window_actions_controller.dart';
import 'package:rein_player/features/playlist/controller/album_content_controller.dart';
import 'package:rein_player/features/settings/controller/settings_controller.dart';
import 'package:rein_player/features/settings/views/menu/menu_item.dart';
import 'package:rein_player/features/settings/views/keyboard_bindings_modal.dart';
import 'package:rein_player/features/settings/views/about_dialog.dart';
import 'package:rein_player/features/settings/views/subtitle_settings_modal.dart';
import 'package:rein_player/features/settings/views/seek_settings_modal.dart';
import 'package:rein_player/utils/constants/rp_enums.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';

List<RpMenuItem> get defaultMenuData {
  final currentType = PlaylistTypeController.to.playlistType.value;
  final availableAudioTracks = AudioTrackController.to.availableAudioTracks;
  final currentAudioTrack = AudioTrackController.to.currentAudioTrack.value;

  return [
    /// Open file
    RpMenuItem(
      text: "Open File",
      icon: Icons.file_open,
      onTap: ControlsController.to.open,
    ),

    /// Subtitles
    RpMenuItem(
      text: "Subtitles",
      icon: Icons.subtitles,
      subMenuItems: [
        RpMenuItem(
          icon: Icons.add,
          text: "Add Subtitle",
          onTap: SubtitleController.to.loadSubtitle,
        ),
        RpMenuItem(
          icon: Icons.remove,
          text: "Disable Subtitle",
          onTap: SubtitleController.to.disableSubtitle,
        ),
        RpMenuItem(
          icon: Icons.settings,
          text: "Subtitle Settings",
          onTap: () {
            Get.dialog(const SubtitleSettingsModal());
          },
        ),
      ],
    ),

    /// Audio
    RpMenuItem(
      text: "Audio",
      icon: Icons.audiotrack,
      subMenuItems:
          _buildAudioTrackMenu(availableAudioTracks, currentAudioTrack),
    ),

    // Preferences submenu
    RpMenuItem(
      text: "Preferences",
      icon: Icons.settings,
      subMenuItems: [
        RpMenuItem(
          icon: Icons.keyboard,
          text: "Keyboard Bindings",
          onTap: () {
            Get.dialog(const KeyboardBindingsModal());
          },
        ),
        RpMenuItem(
          text: "Double-Click Action",
          icon: Icons.mouse,
          subMenuItems: [
            RpMenuItem(
              icon: SettingsController.to.settings.doubleClickAction == 
                    DoubleClickAction.toggleWindowSize
                  ? Icons.check
                  : null,
              text: "Maximize/Minimize Window",
              onTap: () async {
                await SettingsController.to.updateDoubleClickAction(
                  DoubleClickAction.toggleWindowSize,
                );
              },
            ),
            RpMenuItem(
              icon: SettingsController.to.settings.doubleClickAction == 
                    DoubleClickAction.playPause
                  ? Icons.check
                  : null,
              text: "Play/Pause Video",
              onTap: () async {
                await SettingsController.to.updateDoubleClickAction(
                  DoubleClickAction.playPause,
                );
              },
            ),
          ],
        ),
        RpMenuItem(
          icon: Icons.fast_forward,
          text: "Seek Intervals",
          onTap: () {
            final context = Get.context;
            if (context != null) {
              SeekSettingsModal.show(context);
            }
          },
        ),
        RpMenuItem(
          text: "When Playlist Ends",
          icon: Icons.playlist_remove,
          subMenuItems: [
            RpMenuItem(
              icon: SettingsController.to.settings.playlistEndBehavior == 
                    PlaylistEndBehavior.showHomeScreen
                  ? Icons.check
                  : null,
              text: "Show Home Screen",
              onTap: () async {
                await SettingsController.to.updatePlaylistEndBehavior(
                  PlaylistEndBehavior.showHomeScreen,
                );
                RpSnackbar.success(
                  title: 'Playlist End Behavior Updated',
                  message: 'Will show home screen when playlist ends',
                );
              },
            ),
            RpMenuItem(
              icon: SettingsController.to.settings.playlistEndBehavior == 
                    PlaylistEndBehavior.shutdown
                  ? Icons.check
                  : null,
              text: "Shutdown Application",
              onTap: () async {
                await SettingsController.to.updatePlaylistEndBehavior(
                  PlaylistEndBehavior.shutdown,
                );
                RpSnackbar.success(
                  title: 'Playlist End Behavior Updated',
                  message: 'Will shutdown when playlist ends',
                );
              },
            ),
          ],
        ),
      ],
    ),

    /// Playlist
    RpMenuItem(
      text: "Playlist",
      icon: Icons.playlist_play,
      subMenuItems: [
        /// Playlist Type submenu
        RpMenuItem(
          text: "Playlist Type",
          icon: Icons.featured_play_list,
          subMenuItems: [
            RpMenuItem(
              icon: currentType == PlaylistType.defaultPlaylistType
                  ? Icons.check
                  : null,
              text: "Default",
              onTap: () => PlaylistTypeController.to
                  .changePlaylistType(PlaylistType.defaultPlaylistType),
            ),
            RpMenuItem(
              icon: currentType == PlaylistType.potPlayerPlaylistType
                  ? Icons.check
                  : null,
              text: "Pot Player",
              onTap: () => PlaylistTypeController.to
                  .changePlaylistType(PlaylistType.potPlayerPlaylistType),
            ),
          ],
        ),

        /// Shuffle Playlist
        RpMenuItem(
          icon: Icons.shuffle,
          text: "Shuffle Playlist",
          onTap: () {
            Get.find<AlbumContentController>().shufflePlaylistContent();
            RpSnackbar.success(
              title: 'Playlist Shuffled',
              message: 'Playlist order has been randomized',
            );
          },
        ),

        /// Playlist Load Behavior submenu
        RpMenuItem(
          text: "When Loading Files",
          icon: Icons.playlist_add,
          subMenuItems: [
            RpMenuItem(
              icon: SettingsController.to.settings.playlistLoadBehavior == 
                    PlaylistLoadBehavior.clearAndReplace
                  ? Icons.check
                  : null,
              text: "Clear and Replace Playlist",
              onTap: () async {
                await SettingsController.to.updatePlaylistLoadBehavior(
                  PlaylistLoadBehavior.clearAndReplace,
                );
                RpSnackbar.success(
                  title: 'Playlist Behavior Updated',
                  message: 'New files will clear the playlist',
                );
              },
            ),
            RpMenuItem(
              icon: SettingsController.to.settings.playlistLoadBehavior == 
                    PlaylistLoadBehavior.appendToExisting
                  ? Icons.check
                  : null,
              text: "Append to Existing Playlist",
              onTap: () async {
                await SettingsController.to.updatePlaylistLoadBehavior(
                  PlaylistLoadBehavior.appendToExisting,
                );
                RpSnackbar.success(
                  title: 'Playlist Behavior Updated',
                  message: 'New files will be added to playlist',
                );
              },
            ),
          ],
        ),
      ],
    ),

    /// Bookmarks
    RpMenuItem(
      text: "Bookmarks",
      icon: Icons.bookmark,
      subMenuItems: [
        RpMenuItem(
          icon: Icons.bookmark_add,
          text: "Add Bookmark",
          onTap: () async {
            await BookmarkController.to.addBookmark();
          },
        ),
        RpMenuItem(
          icon: Icons.bookmark_border,
          text: "Show Bookmarks",
          onTap: () {
            BookmarkController.to.toggleBookmarkOverlay();
          },
        ),
        RpMenuItem(
          icon: Icons.skip_next,
          text: "Next Bookmark",
          onTap: () async {
            await BookmarkController.to.jumpToNextBookmark();
          },
        ),
        RpMenuItem(
          icon: Icons.skip_previous,
          text: "Previous Bookmark",
          onTap: () async {
            await BookmarkController.to.jumpToPreviousBookmark();
          },
        ),
        RpMenuItem(
          icon: Icons.clear_all,
          text: "Clear All Bookmarks",
          onTap: () {
            final video = VideoAndControlController.to.currentVideo.value;
            if (video != null) {
              // Show confirmation dialog before clearing
              Get.dialog(
                Builder(
                  builder: (context) => AlertDialog(
                    backgroundColor: RpColors.gray_900,
                    title: const Text(
                      'Clear All Bookmarks?',
                      style: TextStyle(color: RpColors.white),
                    ),
                    content: const Text(
                      'This will remove all bookmarks for this video. This action cannot be undone.',
                      style: TextStyle(color: RpColors.white_300),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          BookmarkController.to
                              .clearBookmarksForVideo(video.location);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: RpColors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              RpSnackbar.warning(message: 'No video is currently playing');
            }
          },
        ),
      ],
    ),

    /// A-B Loop Segments
    RpMenuItem(
      text: "A-B Loop Segments",
      icon: Icons.repeat,
      subMenuItems: [
        RpMenuItem(
          icon: Icons.add,
          text: "Add Segment at Current Position",
          onTap: () async {
            ABLoopController.to.addSegmentAtCurrentPosition();
          },
        ),
        RpMenuItem(
          icon: Icons.list,
          text: "Show Segments",
          onTap: () {
            ABLoopController.to.toggleOverlay();
          },
        ),
        RpMenuItem(
          icon: Icons.play_circle,
          text: "Start/Stop A-B Loop Playback",
          onTap: () {
            ABLoopController.to.toggleABLoopPlayback();
          },
        ),
        RpMenuItem(
          icon: Icons.skip_next,
          text: "Next Segment",
          onTap: () async {
            await ABLoopController.to.jumpToNextSegment();
          },
        ),
        RpMenuItem(
          icon: Icons.skip_previous,
          text: "Previous Segment",
          onTap: () async {
            await ABLoopController.to.jumpToPreviousSegment();
          },
        ),
        RpMenuItem(
          icon: Icons.file_upload,
          text: "Import PBF File...",
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pbf'],
            );
            if (result != null && result.files.single.path != null) {
              await ABLoopController.to.importFromPBF(result.files.single.path!);
            }
          },
        ),
        RpMenuItem(
          icon: Icons.file_download,
          text: "Export to PBF File...",
          onTap: () async {
            await ABLoopController.to.exportToPBF();
          },
        ),
        RpMenuItem(
          icon: Icons.clear_all,
          text: "Clear All Segments",
          onTap: () {
            final segments = ABLoopController.to.segments;
            if (segments.isEmpty) {
              RpSnackbar.info(message: 'No segments to clear');
              return;
            }

            // Show confirmation dialog
            Get.dialog(
              Builder(
                builder: (context) => AlertDialog(
                  backgroundColor: RpColors.gray_900,
                  title: const Text(
                    'Clear All Segments?',
                    style: TextStyle(color: RpColors.white),
                  ),
                  content: const Text(
                    'This will remove all A-B loop segments for this video. This action cannot be undone.',
                    style: TextStyle(color: RpColors.white_300),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ABLoopController.to.clearSegments();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: RpColors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),

    /// About
    RpMenuItem(
      text: "About",
      icon: Icons.info_outline,
      onTap: () {
        Get.dialog(const RpAboutDialog());
      },
    ),

    /// Exit
    RpMenuItem(
      text: "Exit",
      icon: Icons.exit_to_app,
      onTap: () {
        WindowActionsController.to.closeWindow();
      },
    ),
  ];
}

List<RpMenuItem> _buildAudioTrackMenu(
    List<AudioTrack> availableAudioTracks, AudioTrack? currentAudioTrack) {
  List<RpMenuItem> audioMenuItems = [];
  // If no tracks are available, show a message
  if (availableAudioTracks.isEmpty) {
    audioMenuItems.add(
      RpMenuItem(
        icon: null,
        text: "No additional tracks available",
        enabled: false,
        onTap: () {},
      ),
    );
    return audioMenuItems;
  }

  // Add all available audio tracks
  for (int i = 0; i < availableAudioTracks.length; i++) {
    final track = availableAudioTracks[i];
    final isSelected = currentAudioTrack?.id == track.id;
    final displayName = AudioTrackController.to.getAudioTrackDisplayName(track);

    audioMenuItems.add(
      RpMenuItem(
        icon: isSelected ? Icons.check : null,
        text: displayName,
        onTap: () async {
          try {
            await AudioTrackController.to.selectAudioTrack(track);
          } catch (e) {
            //do nothing
          }
        },
      ),
    );
  }

  return audioMenuItems;
}

ContextMenu createContextMenu() {
  return ContextMenu(
    entries: convertToContextMenuEntries(defaultMenuData),
    boxDecoration: const BoxDecoration(
      color: RpColors.gray_800,
      borderRadius: BorderRadius.zero,
    ),
    padding: EdgeInsets.zero,
  );
}

List<ContextMenuEntry> convertToContextMenuEntries(List<RpMenuItem> items) {
  return items.map((item) {
    if (item.hasSubMenu) {
      return MenuItem.submenu(
        label: item.text,
        icon: item.icon,
        items: convertToContextMenuEntries(item.subMenuItems!),
      );
    } else {
      return MenuItem(
        label: item.text,
        icon: item.icon,
        enabled: item.enabled,
        value: item.text,
        onSelected: item.onTap ?? () {},
      );
    }
  }).toList();
}
