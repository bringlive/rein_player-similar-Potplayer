import 'dart:io';

import 'package:rein_player/features/playback/models/video_audio_item.dart';

import '../../features/playlist/models/playlist_item.dart';
import '../../features/playlist/models/playlist_item_type.dart';
import 'package:path/path.dart' as path;

import '../constants/rp_extensions.dart';

class RpMediaHelper {
  RpMediaHelper._();

  static PlaylistItemType getPlaylistItemType(String filePath) {
    final extension = path.extension(filePath).toLowerCase().trim();
    if (RpFileExtensions.videoExtensions.contains(extension)) {
      return PlaylistItemType.VIDEO;
    }

    if (RpFileExtensions.audioExtensions.contains(extension)) {
      return PlaylistItemType.AUDIO;
    }

    if (RpFileExtensions.subtitleExtensions.contains(extension)) {
      return PlaylistItemType.SUBTITLE;
    }

    if (FileSystemEntity.typeSync(filePath) == FileSystemEntityType.directory) {
      return PlaylistItemType.DIRECTORY;
    }

    return PlaylistItemType.UNSUPPORTED;
  }

  static bool isPlaylistItemSupported(String path) =>
      getPlaylistItemType(path) != PlaylistItemType.UNSUPPORTED;

  static bool isPlaylistItemSupportedAndNotSubtitle(String path) {
    final type = getPlaylistItemType(path);
    return type != PlaylistItemType.UNSUPPORTED &&
        type != PlaylistItemType.SUBTITLE;
  }

  static bool isMediaFile(String filePath) {
    final allTypes = [
      ...RpFileExtensions.audioExtensions,
      ...RpFileExtensions.videoExtensions,
    ];
    final extension = path.extension(filePath).toLowerCase().trim();
    return allTypes.contains(extension);
  }

  static VideoOrAudioItem getCurrentVideoInfoFromUrl(String filePath) {
    String name = path.basenameWithoutExtension(filePath);
    return VideoOrAudioItem(name, filePath);
  }

  static Future<List<PlaylistItem>> getMediaFilesInDirectory(
      String dirPath) async {
    final List<PlaylistItem> mediaFiles = [];
    final directory = Directory(dirPath);
    try {
      await for (var entity in directory.list()) {
        final name = path.basename(entity.path);
        if (!RpMediaHelper.isPlaylistItemSupportedAndNotSubtitle(entity.path)) {
          continue;
        }

        mediaFiles.add(PlaylistItem(
          name: name,
          location: entity.path,
          isDirectory: entity is Directory,
          type: RpMediaHelper.getPlaylistItemType(entity.path),
        ));
      }
    } catch (e) {
      //do nothing
    }

    /// Sort: folders first, then files
    mediaFiles.sort(sortMediaFiles);

    return mediaFiles;
  }

  static int sortMediaFiles(a, b, {bool isDirectory = false}) {
    late RegExpMatch? matchA;
    late RegExpMatch? matchB;
    RegExp numberPrefix = RegExp(r'^(\d+)[\.\-_\)\s]*?(.*)');

    if (a.runtimeType == PlaylistItem && b.runtimeType == PlaylistItem) {
      if (a.isDirectory != b.isDirectory) {
        return a.isDirectory ? -1 : 1;
      }
      matchA = numberPrefix.firstMatch(a.name);
      matchB = numberPrefix.firstMatch(b.name);
    } else {
      matchA = numberPrefix.firstMatch(a);
      matchB = numberPrefix.firstMatch(b);
    }

    if (matchA != null && matchB != null) {
      int numberA = int.parse(matchA.group(1)!);
      int numberB = int.parse(matchB.group(1)!);
      if (numberA != numberB) {
        return numberA.compareTo(numberB);
      }
      return matchA.group(2)!.compareTo(matchB.group(2)!);
    }

    if (matchA != null) return -1;
    if (matchB != null) return 1;

    return a.name.compareTo(b.name);
  }

  static Future<List<PlaylistItem>> flattenDropItemsFromDirectory(
    String dirPath,
  ) async {
    final List<PlaylistItem> mediaFiles = [];

    try {
      final entries = await Directory(dirPath).list(recursive: false).toList();

      final List<FileSystemEntity> directories = [];
      final List<FileSystemEntity> files = [];

      for (final entry in entries) {
        final isDir = await FileSystemEntity.isDirectory(entry.path);
        if (isDir) {
          directories.add(entry);
        } else {
          files.add(entry);
        }
      }

      // Sort directories using natural sorting by name
      directories.sort((a, b) {
        final nameA = a.path.split(Platform.pathSeparator).last;
        final nameB = b.path.split(Platform.pathSeparator).last;
        return RpMediaHelper.sortMediaFiles(nameA, nameB, isDirectory: true);
      });

      for (final file in files) {
        final path = file.path;
        final name = path.split(Platform.pathSeparator).last;

        // Skip unsupported formats
        if (!RpMediaHelper.isPlaylistItemSupportedAndNotSubtitle(path)) {
          continue;
        }
        mediaFiles.add(
          PlaylistItem(
            name: name,
            location: path,
            isDirectory: false,
            type: RpMediaHelper.getPlaylistItemType(path),
          ),
        );
      }
      mediaFiles.sort(RpMediaHelper.sortMediaFiles);

      for (final directory in directories) {
        final subItems = await flattenDropItemsFromDirectory(directory.path);
        mediaFiles.addAll(subItems);
      }
    } catch (e) {
      //do nothing
    }

    return mediaFiles;
  }
}
