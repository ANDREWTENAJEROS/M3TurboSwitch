#!/usr/bin/env bash
set -euo pipefail

APP_NAME="M3TurboSwitch"
BUNDLE_ID="com.m3turboswitch.app"
MIN_MACOS="13.0"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"
RELEASE_DIR="$BUILD_DIR/release"
APP_DIR="$RELEASE_DIR/${APP_NAME}.app"
DMG_PATH="$RELEASE_DIR/${APP_NAME}.dmg"

mkdir -p "$RELEASE_DIR"

pushd "$ROOT_DIR" >/dev/null

# Build a universal binary for Intel + Apple Silicon.
swift build -c release --arch arm64 --arch x86_64

BIN_PATH="$ROOT_DIR/.build/apple/Products/Release/M3TurboSwitchApp"
if [[ ! -x "$BIN_PATH" ]]; then
  echo "Expected binary not found at: $BIN_PATH"
  exit 1
fi

rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

cp "$BIN_PATH" "$APP_DIR/Contents/MacOS/$APP_NAME"

cat > "$APP_DIR/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>${APP_NAME}</string>
  <key>CFBundleDisplayName</key>
  <string>${APP_NAME}</string>
  <key>CFBundleExecutable</key>
  <string>${APP_NAME}</string>
  <key>CFBundleIdentifier</key>
  <string>${BUNDLE_ID}</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>CFBundleShortVersionString</key>
  <string>0.1.0</string>
  <key>LSMinimumSystemVersion</key>
  <string>${MIN_MACOS}</string>
  <key>LSUIElement</key>
  <true/>
</dict>
</plist>
PLIST

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

# Optional local signing for easier first run.
if [[ "${CODESIGN_IDENTITY:-}" != "" ]]; then
  codesign --force --deep --sign "$CODESIGN_IDENTITY" "$APP_DIR"
fi

rm -f "$DMG_PATH"
hdiutil create \
  -volname "$APP_NAME" \
  -srcfolder "$APP_DIR" \
  -ov -format UDZO \
  "$DMG_PATH"

popd >/dev/null

echo "App bundle: $APP_DIR"
echo "DMG: $DMG_PATH"
