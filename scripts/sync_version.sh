#!/bin/bash

# Script to sync version from pubspec.yaml to app_info.dart
# This ensures a single source of truth for version information

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR}/.."
PUBSPEC_FILE="${PROJECT_DIR}/pubspec.yaml"
APP_INFO_FILE="${PROJECT_DIR}/lib/utils/constants/app_info.dart"

# Extract version from pubspec.yaml
extract_version() {
  local raw_version
  raw_version=$(grep "^version:" "${PUBSPEC_FILE}" | awk '{print $2}' | tr -d '"' | tr -d "'")
  echo "${raw_version}"
}

# Extract description from pubspec.yaml
extract_description() {
  local description
  description=$(grep "^description:" "${PUBSPEC_FILE}" | sed 's/^description: *//' | tr -d '"' | tr -d "'")
  echo "${description}"
}

# Main execution
VERSION_FULL=$(extract_version)
VERSION=$(echo "${VERSION_FULL}" | sed 's/+.*//')
BUILD_NUMBER=$(echo "${VERSION_FULL}" | grep -o '+.*' | tr -d '+' || echo "1")
DESCRIPTION=$(extract_description)

echo "Syncing version information..."
echo "  Version: ${VERSION}"
echo "  Build Number: ${BUILD_NUMBER}"
echo "  Description: ${DESCRIPTION}"

# Update app_info.dart
cat > "${APP_INFO_FILE}" << EOF
/// Application information constants
/// This file serves as the single source of truth for app version
/// It's updated automatically from pubspec.yaml during build
class AppInfo {
  AppInfo._();

  /// Application name
  static const String appName = 'ReinPlayer';

  /// Current version - should match pubspec.yaml
  static const String version = '${VERSION}';

  /// Build number
  static const String buildNumber = '${BUILD_NUMBER}';

  /// Full version string
  static String get fullVersion => '\$version+\$buildNumber';

  /// Description
  static const String description =
      '${DESCRIPTION}';

  /// GitHub repository
  static const String repository = 'https://github.com/Ahurein/rein_player';

  /// Short description for CLI
  static const String shortDescription =
      'A modern video player for Linux and macOS';
}
EOF

echo "✅ Version information synced successfully!"
echo "   Updated: ${APP_INFO_FILE}"

