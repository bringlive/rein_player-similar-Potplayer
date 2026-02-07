import 'package:rein_player/features/playback/models/ab_loop_segment.dart';

class PBFBookmarkFile {
  final String videoPath;
  final List<ABLoopSegment> segments;
  final DateTime lastModified;

  PBFBookmarkFile({
    required this.videoPath,
    required this.segments,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  // Get segments sorted by start time
  List<ABLoopSegment> get sortedSegments {
    final sorted = List<ABLoopSegment>.from(segments);
    sorted.sort((a, b) => a.startTimeMs.compareTo(b.startTimeMs));
    return sorted;
  }

  // Check if any segments overlap
  bool get hasOverlappingSegments {
    final sorted = sortedSegments;
    for (int i = 0; i < sorted.length - 1; i++) {
      if (sorted[i].endTimeMs > sorted[i + 1].startTimeMs) {
        return true;
      }
    }
    return false;
  }

  PBFBookmarkFile copyWith({
    String? videoPath,
    List<ABLoopSegment>? segments,
    DateTime? lastModified,
  }) {
    return PBFBookmarkFile(
      videoPath: videoPath ?? this.videoPath,
      segments: segments ?? this.segments,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  String toString() {
    return 'PBFBookmarkFile(videoPath: $videoPath, segments: ${segments.length}, lastModified: $lastModified)';
  }
}
