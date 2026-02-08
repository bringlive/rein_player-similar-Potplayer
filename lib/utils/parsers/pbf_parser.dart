import 'dart:io';
import 'package:rein_player/features/playback/models/ab_loop_segment.dart';
import 'package:rein_player/features/playback/models/pbf_bookmark_file.dart';

class PBFParser {
  /// Parse a PBF file from the given file path
  static Future<PBFBookmarkFile> parseFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('PBF file not found', filePath);
    }

    final content = await file.readAsString();
    return parseContent(content, filePath);
  }

  /// Parse PBF content string
  static PBFBookmarkFile parseContent(String content, String videoPath) {
    final segments = <ABLoopSegment>[];
    final lines = content.split('\n');

    bool inPlayRepeatSection = false;
    final segmentData = <int, Map<String, dynamic>>{};

    for (final line in lines) {
      final trimmedLine = line.trim();

      // Check for [PlayRepeat] section
      if (trimmedLine == '[PlayRepeat]') {
        inPlayRepeatSection = true;
        continue;
      }

      // Skip empty lines or lines outside PlayRepeat section
      if (trimmedLine.isEmpty || !inPlayRepeatSection) {
        continue;
      }

      // Stop parsing if we hit another section
      if (trimmedLine.startsWith('[') && trimmedLine.endsWith(']')) {
        break;
      }

      try {
        // Parse segment lines
        if (trimmedLine.contains('=')) {
          final parts = trimmedLine.split('=');
          if (parts.length != 2) continue;

          final key = parts[0].trim();
          final value = parts[1].trim();

          // Check if this is a main segment line (just a number)
          if (RegExp(r'^\d+$').hasMatch(key)) {
            final index = int.parse(key);
            segmentData.putIfAbsent(index, () => {});
            segmentData[index]!['line'] = trimmedLine;
            segmentData[index]!['index'] = index;
          }
          // Check if this is a delay line (number_d)
          else if (key.endsWith('_d')) {
            final indexStr = key.substring(0, key.length - 2);
            if (RegExp(r'^\d+$').hasMatch(indexStr)) {
              final index = int.parse(indexStr);
              segmentData.putIfAbsent(index, () => {});
              segmentData[index]!['delayMs'] = int.tryParse(value) ?? 0;
            }
          }
          // Check if this is an enabled line (number_e)
          else if (key.endsWith('_e')) {
            final indexStr = key.substring(0, key.length - 2);
            if (RegExp(r'^\d+$').hasMatch(indexStr)) {
              final index = int.parse(indexStr);
              segmentData.putIfAbsent(index, () => {});
              segmentData[index]!['delayEnabled'] = value == '1';
            }
          }
        }
      } catch (e) {
        // Skip malformed lines
        continue;
      }
    }

    // Convert segment data to ABLoopSegment objects
    final sortedIndices = segmentData.keys.toList()..sort();
    for (final index in sortedIndices) {
      final data = segmentData[index]!;
      if (data.containsKey('line')) {
        try {
          final segment = ABLoopSegment.fromPBFLine(
            index,
            data['line'] as String,
            data['delayMs'] as int?,
            data['delayEnabled'] as bool?,
          );
          segments.add(segment);
        } catch (e) {
          // Skip invalid segments
          continue;
        }
      }
    }

    return PBFBookmarkFile(
      videoPath: videoPath,
      segments: segments,
      lastModified: DateTime.now(),
    );
  }

  /// Export PBFBookmarkFile to a file
  static Future<void> exportToFile(
      PBFBookmarkFile pbf, String filePath) async {
    final content = generatePBFContent(pbf.segments);
    final file = File(filePath);
    await file.writeAsString(content);
  }

  /// Generate PBF content string from segments
  static String generatePBFContent(List<ABLoopSegment> segments) {
    final buffer = StringBuffer();
    buffer.writeln('[PlayRepeat]');

    final sortedSegments = List<ABLoopSegment>.from(segments);
    sortedSegments.sort((a, b) => a.sequenceIndex.compareTo(b.sequenceIndex));

    // Reindex segments to ensure consecutive indices
    for (int i = 0; i < sortedSegments.length; i++) {
      final segment = sortedSegments[i].copyWith(sequenceIndex: i);

      buffer.writeln(segment.toPBFLine());
      buffer.writeln('${segment.sequenceIndex}_d=${segment.repeatDelayMs}');
      buffer.writeln(
          '${segment.sequenceIndex}_e=${segment.delayEnabled ? 1 : 0}');
    }

    // Add empty line at the end (PotPlayer format)
    buffer.writeln('${sortedSegments.length}=');

    return buffer.toString();
  }

  /// Validate if a file is a valid PBF file
  static Future<bool> isValidPBFFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      final content = await file.readAsString();
      return content.contains('[PlayRepeat]');
    } catch (e) {
      return false;
    }
  }

  /// Get PBF file path for a given video path
  static String getPBFPathForVideo(String videoPath) {
    return videoPath.replaceAll(RegExp(r'\.\w+$'), '.pbf');
  }
}
