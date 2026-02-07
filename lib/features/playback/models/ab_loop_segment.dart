class ABLoopSegment {
  final int sequenceIndex; // 0-based list position
  final int startTimeMs; // Absolute start in milliseconds
  final int durationMs; // Duration in milliseconds
  final int loopCount; // Number of times to repeat
  final String? title; // Optional label for grouping
  final int repeatDelayMs; // Delay before repeating (stays on last frame)
  final bool delayEnabled; // Whether delay is active

  ABLoopSegment({
    required this.sequenceIndex,
    required this.startTimeMs,
    required this.durationMs,
    required this.loopCount,
    this.title,
    this.repeatDelayMs = 0,
    this.delayEnabled = false,
  });

  // Computed properties
  int get endTimeMs => startTimeMs + durationMs;
  Duration get startTime => Duration(milliseconds: startTimeMs);
  Duration get endTime => Duration(milliseconds: endTimeMs);
  Duration get duration => Duration(milliseconds: durationMs);
  Duration get repeatDelay => Duration(milliseconds: repeatDelayMs);

  // Format timestamp as HH:MM:SS.mmm or MM:SS.mmm
  String get formattedStartTime => _formatTime(startTimeMs);
  String get formattedEndTime => _formatTime(endTimeMs);
  String get formattedDuration => _formatTime(durationMs);

  String _formatTime(int milliseconds) {
    final totalSeconds = milliseconds ~/ 1000;
    final ms = milliseconds % 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}';
    }
  }

  // JSON serialization for storage
  Map<String, dynamic> toJson() {
    return {
      'sequenceIndex': sequenceIndex,
      'startTimeMs': startTimeMs,
      'durationMs': durationMs,
      'loopCount': loopCount,
      'title': title,
      'repeatDelayMs': repeatDelayMs,
      'delayEnabled': delayEnabled,
    };
  }

  factory ABLoopSegment.fromJson(Map<String, dynamic> json) {
    return ABLoopSegment(
      sequenceIndex: json['sequenceIndex'] as int,
      startTimeMs: json['startTimeMs'] as int,
      durationMs: json['durationMs'] as int,
      loopCount: json['loopCount'] as int,
      title: json['title'] as String?,
      repeatDelayMs: json['repeatDelayMs'] as int? ?? 0,
      delayEnabled: json['delayEnabled'] as bool? ?? false,
    );
  }

  // PBF format conversion
  // Format: "N=START_MS*DURATION_MS*LOOP_COUNT*TITLE"
  String toPBFLine() {
    final titlePart = title != null && title!.isNotEmpty ? '*$title' : '';
    return '$sequenceIndex=$startTimeMs*$durationMs*$loopCount$titlePart';
  }

  // Parse from PBF line: "3=1174073*1029*4*good job"
  static ABLoopSegment fromPBFLine(
    int index,
    String line,
    int? delayMs,
    bool? delayEnabled,
  ) {
    // Remove index prefix (e.g., "3=")
    final parts = line.split('=');
    if (parts.length < 2) {
      throw FormatException('Invalid PBF line format: $line');
    }

    // Split the value part by asterisk
    final values = parts[1].split('*');
    if (values.length < 3) {
      throw FormatException('Invalid PBF value format: ${parts[1]}');
    }

    final startTimeMs = int.parse(values[0].trim());
    final durationMs = int.parse(values[1].trim());
    final loopCount = int.parse(values[2].trim());
    final title = values.length > 3 ? values[3].trim() : null;

    return ABLoopSegment(
      sequenceIndex: index,
      startTimeMs: startTimeMs,
      durationMs: durationMs,
      loopCount: loopCount,
      title: title,
      repeatDelayMs: delayMs ?? 0,
      delayEnabled: delayEnabled ?? false,
    );
  }

  ABLoopSegment copyWith({
    int? sequenceIndex,
    int? startTimeMs,
    int? durationMs,
    int? loopCount,
    String? title,
    int? repeatDelayMs,
    bool? delayEnabled,
  }) {
    return ABLoopSegment(
      sequenceIndex: sequenceIndex ?? this.sequenceIndex,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      durationMs: durationMs ?? this.durationMs,
      loopCount: loopCount ?? this.loopCount,
      title: title ?? this.title,
      repeatDelayMs: repeatDelayMs ?? this.repeatDelayMs,
      delayEnabled: delayEnabled ?? this.delayEnabled,
    );
  }

  @override
  String toString() {
    return 'ABLoopSegment(index: $sequenceIndex, start: $formattedStartTime, duration: $formattedDuration, loops: $loopCount, title: $title)';
  }
}
