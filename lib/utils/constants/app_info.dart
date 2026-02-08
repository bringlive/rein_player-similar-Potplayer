/// Application information constants
/// This file serves as the single source of truth for app version
/// It's updated automatically from pubspec.yaml during build
class AppInfo {
  AppInfo._();

  /// Application name
  static const String appName = 'ReinPlayer';

  /// Current version - should match pubspec.yaml
  static const String version = '1.1.0';

  /// Build number
  static const String buildNumber = '2';

  /// Full version string
  static String get fullVersion => '$version+$buildNumber';

  /// Description
  static const String description =
      'A fast and intuitive video player with a clean UI, inspired by PotPlayer, designed for Linux and macOS';

  /// GitHub repository
  static const String repository = 'https://github.com/Ahurein/rein_player';

  /// Short description for CLI
  static const String shortDescription =
      'A modern video player for Linux and macOS';
}
