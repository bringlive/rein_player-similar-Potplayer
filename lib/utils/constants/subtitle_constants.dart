/// Constants for subtitle customization
class SubtitleConstants {
  SubtitleConstants._();

  /// Common fonts available for subtitles
  static const List<String> availableFonts = [
    'Segoe UI',
    'Arial',
    'Helvetica',
    'Times New Roman',
    'Courier New',
    'Georgia',
    'Verdana',
    'Trebuchet MS',
    'Comic Sans MS',
    'Impact',
    'Roboto',
    'Open Sans',
  ];

  /// Font size range
  static const double minFontSize = 8.0;
  static const double maxFontSize = 72.0;
  static const double defaultFontSize = 20.0;

  /// Position adjustment step (in pixels)
  static const double positionStep = 5.0;
  static const double maxPosition = 200.0;

  /// Default outline width
  static const double defaultOutlineWidth = 1.5;
  static const double maxOutlineWidth = 5.0;
}
