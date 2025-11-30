#!/bin/bash

set -e

PLATFORM=$1
CURRENT_DIR="$(dirname "$0")"
PROJECT_DIR="${CURRENT_DIR}/.."

function extract_version() {
  local raw_version
  raw_version=$(grep "^version:" "${PROJECT_DIR}/pubspec.yaml" | awk '{print $2}' | tr -d '"')
  echo "${raw_version}" | sed 's/+.*//'
}

function validate_version() {
  local version="$1"
  if ! [[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format: ${version}"
    exit 1
  fi
}

function build_deb_package() {
    PACKAGE_DIR="${PROJECT_DIR}/build/deb_package"
    rm -rf "${PACKAGE_DIR}"
    VERSION="$(extract_version)"
    validate_version "${VERSION}"
    sed -i "s/^Version:.*/Version: ${VERSION}/" "${CURRENT_DIR}/deb/DEBIAN/control"
    cp -fr "${CURRENT_DIR}/deb/." "${PACKAGE_DIR}"
    mkdir -p "${PACKAGE_DIR}/usr/bin"
    mkdir -p "${PACKAGE_DIR}/usr/lib/reinplayer"
    for library in "${PROJECT_DIR}/build/linux/x64/release/bundle/lib/"*.so; do
      strip "$library"
    done
    cp -fr "${PROJECT_DIR}/build/linux/x64/release/bundle/." "${PACKAGE_DIR}/usr/lib/reinplayer"
    ln -sf "../lib/reinplayer/rein_player" "${PACKAGE_DIR}/usr/bin/reinplayer"
    dpkg-deb --build --root-owner-group "${PACKAGE_DIR}" "${PROJECT_DIR}/build/reinplayer_${VERSION}_linux_amd64.deb"
}

function build_snap_package() {
    PACKAGE_DIR="${CURRENT_DIR}/snap/rein_player"
    rm -rf "${PACKAGE_DIR}"
    VERSION="$(extract_version)"
    validate_version "${VERSION}"
    mkdir -p "${PACKAGE_DIR}"
    sed -i "s/^version:.*/version: ${VERSION}/" "${CURRENT_DIR}/snap/snap/snapcraft.yaml"
    cp -fr "${PROJECT_DIR}/build/linux/x64/release/bundle/." "${PACKAGE_DIR}"
    # Copy GUI files to the package directory
    mkdir -p "${PACKAGE_DIR}/gui"
    cp "${CURRENT_DIR}/snap/snap/gui/reinplayer.desktop" "${PACKAGE_DIR}/gui/"
    cp "${CURRENT_DIR}/snap/snap/gui/reinplayer.png" "${PACKAGE_DIR}/gui/"
    for library in "${PACKAGE_DIR}/lib/"*.so; do
        strip "$library"
    done
    echo "Snap package prepared. The snapcraft build will include version ${VERSION} in the filename."
}

function build_appimage_package() {
    APP_IMAGE_TOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    PACKAGE_DIR="${PROJECT_DIR}/build/ReinPlayer.AppDir"
    VERSION="$(extract_version)"
    validate_version "${VERSION}"
    if ! command -v appimagetool &> /dev/null; then
      wget -O appimagetool "${APP_IMAGE_TOOL_URL}"
      chmod +x appimagetool
      mv appimagetool /usr/local/bin/appimagetool
    fi
    rm -rf "${PACKAGE_DIR}"
    cp -fr "${CURRENT_DIR}/appimage/." "${PACKAGE_DIR}"
    cp -fr "${PROJECT_DIR}/build/linux/x64/release/bundle/." "${PACKAGE_DIR}"
    mv "${PACKAGE_DIR}/rein_player" "${PACKAGE_DIR}/reinplayer"
    for library in "${PACKAGE_DIR}/lib/"*.so; do
        strip "$library"
    done
    appimagetool "${PACKAGE_DIR}"
    mv "./ReinPlayer-x86_64.AppImage" "${PROJECT_DIR}/build/ReinPlayer-${VERSION}-x86_64.AppImage"
}
function build_dmg_package() {
    VERSION="$(extract_version)"
    validate_version "${VERSION}"

    APP_PATH="${PROJECT_DIR}/build/macos/Build/Products/Release/rein_player.app"
    OUTPUT_DIR="${PROJECT_DIR}/dist/dmg"
    DMG_NAME="ReinPlayer-v${VERSION}.dmg"
    DMG_PATH="${OUTPUT_DIR}/${DMG_NAME}"

    # Make sure output dir exists
    mkdir -p "${OUTPUT_DIR}"

    # Check if create-dmg is installed
    if ! command -v create-dmg &> /dev/null; then
        echo "'create-dmg' not found. Installing via Homebrew..."
        if command -v brew &> /dev/null; then
            brew install create-dmg
        else
            echo "Homebrew not found. Please install create-dmg manually."
            exit 1
        fi
    fi

    # Prepare a staging folder that contains the app bundle for the DMG
    STAGING_DIR="${OUTPUT_DIR}/staging"
    rm -rf "${STAGING_DIR}"
    mkdir -p "${STAGING_DIR}"
    cp -R "${APP_PATH}" "${STAGING_DIR}/"

    # Remove old DMG if exists
    if [ -f "${DMG_PATH}" ]; then
        echo "Removing existing DMG: ${DMG_PATH}"
        rm "${DMG_PATH}"
    fi

    echo "Creating DMG ${DMG_NAME}..."

    create-dmg \
        --volname "Rein Player" \
        --icon "rein_player.app" 200 190 \
        --app-drop-link 600 185 \
        --window-pos 200 120 \
        --window-size 800 400 \
        --icon-size 100 \
        --hide-extension "rein_player.app" \
        "${DMG_PATH}" \
        "${STAGING_DIR}"

    echo "DMG created at: ${DMG_PATH}"
}

# Dispatch by platform
if [[ "$PLATFORM" == "deb" ]]; then
  build_deb_package
elif [[ "$PLATFORM" == "snap" ]]; then
  build_snap_package
elif [[ "$PLATFORM" == "appimage" ]]; then
  build_appimage_package
elif [[ "$PLATFORM" == "macos" ]]; then
  build_dmg_package
else
  echo "Unknown platform: $PLATFORM"
  exit 1
fi