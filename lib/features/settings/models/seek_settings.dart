import 'package:rein_player/utils/constants/rp_enums.dart';
import 'package:rein_player/utils/constants/rp_keys.dart';

class SeekSettings {
  SeekMode mode;
  
  // For adaptive mode (percentage of video duration)
  double regularSeekPercentage;
  double bigSeekPercentage;
  
  // For fixed mode (seconds)
  int regularSeekSeconds;
  int bigSeekSeconds;

  SeekSettings({
    this.mode = SeekMode.adaptive,
    this.regularSeekPercentage = 0.01,  // 1%
    this.bigSeekPercentage = 0.05,      // 5%
    this.regularSeekSeconds = 5,        // 5 seconds
    this.bigSeekSeconds = 30,           // 30 seconds
  });

  factory SeekSettings.fromJson(Map<String, dynamic> json) {
    SeekMode savedMode = SeekMode.values.byName(
      json[RpKeysConstants.seekModeKey] ?? SeekMode.adaptive.name,
    );

    return SeekSettings(
      mode: savedMode,
      regularSeekPercentage: (json[RpKeysConstants.regularSeekPercentageKey] as num?)?.toDouble() ?? 0.01,
      bigSeekPercentage: (json[RpKeysConstants.bigSeekPercentageKey] as num?)?.toDouble() ?? 0.05,
      regularSeekSeconds: json[RpKeysConstants.regularSeekSecondsKey] as int? ?? 5,
      bigSeekSeconds: json[RpKeysConstants.bigSeekSecondsKey] as int? ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RpKeysConstants.seekModeKey: mode.name,
      RpKeysConstants.regularSeekPercentageKey: regularSeekPercentage,
      RpKeysConstants.bigSeekPercentageKey: bigSeekPercentage,
      RpKeysConstants.regularSeekSecondsKey: regularSeekSeconds,
      RpKeysConstants.bigSeekSecondsKey: bigSeekSeconds,
    };
  }

  SeekSettings copyWith({
    SeekMode? mode,
    double? regularSeekPercentage,
    double? bigSeekPercentage,
    int? regularSeekSeconds,
    int? bigSeekSeconds,
  }) {
    return SeekSettings(
      mode: mode ?? this.mode,
      regularSeekPercentage: regularSeekPercentage ?? this.regularSeekPercentage,
      bigSeekPercentage: bigSeekPercentage ?? this.bigSeekPercentage,
      regularSeekSeconds: regularSeekSeconds ?? this.regularSeekSeconds,
      bigSeekSeconds: bigSeekSeconds ?? this.bigSeekSeconds,
    );
  }

  // Helper methods for display
  String getRegularSeekDisplay() {
    if (mode == SeekMode.adaptive) {
      return '${(regularSeekPercentage * 100).toStringAsFixed(1)}%';
    } else {
      return '${regularSeekSeconds}s';
    }
  }

  String getBigSeekDisplay() {
    if (mode == SeekMode.adaptive) {
      return '${(bigSeekPercentage * 100).toStringAsFixed(1)}%';
    } else {
      return '${bigSeekSeconds}s';
    }
  }
}
