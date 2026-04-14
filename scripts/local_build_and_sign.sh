#!/usr/bin/env bash
set -euo pipefail

APP_NAME="M3TurboSwitch"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$ROOT_DIR/build/local"
APP_PATH="$OUT_DIR/${APP_NAME}.app"

cd "$ROOT_DIR"

swift build -c release --arch x86_64

BIN_PATH=""
for candidate in \
  "$ROOT_DIR/.build/x86_64-apple-macosx/release/M3TurboSwitchApp" \
  "$ROOT_DIR/.build/apple/Products/Release/M3TurboSwitchApp"
do
  if [[ -x "$candidate" ]]; then
    BIN_PATH="$candidate"
    break
  fi
done

if [[ -z "$BIN_PATH" ]]; then
  echo "Could not find built executable M3TurboSwitchApp under .build/."
  exit 1
fi

rm -rf "$APP_PATH"
mkdir -p "$APP_PATH/Contents/MacOS"

cp "$BIN_PATH" "$APP_PATH/Contents/MacOS/$APP_NAME"

cat > "$APP_PATH/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>${APP_NAME}</string>
  <key>CFBundleExecutable</key>
  <string>${APP_NAME}</string>
  <key>CFBundleIdentifier</key>
  <string>com.m3turboswitch.app</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>CFBundleShortVersionString</key>
  <string>0.1.0</string>
  <key>LSMinimumSystemVersion</key>
  <string>13.0</string>
  <key>LSUIElement</key>
  <true/>
</dict>
</plist>
PLIST

chmod +x "$APP_PATH/Contents/MacOS/$APP_NAME"
codesign --force --deep --sign - "$APP_PATH"

echo "$APP_PATH"
