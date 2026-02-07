class VideoBookmark {
  // Position in seconds
  final int timestamp;
  final String name;
  final DateTime createdAt;

  VideoBookmark({
    required this.timestamp,
    this.name = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Format timestamp as HH:MM:SS or MM:SS
  String get formattedTimestamp {
    final hours = timestamp ~/ 3600;
    final minutes = (timestamp % 3600) ~/ 60;
    final seconds = timestamp % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VideoBookmark.fromJson(Map<String, dynamic> json) {
    return VideoBookmark(
      timestamp: json['timestamp'] as int,
      name: json['name'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  VideoBookmark copyWith({
    int? timestamp,
    String? name,
    DateTime? createdAt,
  }) {
    return VideoBookmark(
      timestamp: timestamp ?? this.timestamp,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'VideoBookmark(timestamp: $timestamp, name: $name, formattedTime: $formattedTimestamp)';
  }
}
