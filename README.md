# M3TurboSwitch (Simple Turbo Boost Menu Bar App)

A minimal macOS menu bar app blueprint inspired by Turbo Boost Switcher, focused on only core features:

- Turbo Boost ON/OFF icon in menu bar.
- Enable/disable Turbo Boost manually.
- Optional **Disable Turbo Boost on boot**.
- Optional **Open at Login**.
- Show only **current CPU temperature**.
- No about/help/update UI, no charts, no refresh-rate controls, no hotkeys, no localization, no status text.

## CPU + macOS compatibility

- **CPU target**: Intel only (`x86_64`).
- **Toolchain target**: Swift **5.8.1** compatible project settings.
- **Minimum macOS target**: Ventura (**13.0+**), including Darwin 22.x (e.g. 22.6.0).

## Build a `.app` + `.dmg` on your Mac

Run this on a macOS machine (not Linux):

```bash
./scripts/build_and_package.sh
```

Outputs:

- App bundle: `build/release/M3TurboSwitch.app`
- DMG: `build/release/M3TurboSwitch.dmg`

Install flow:

1. Open `M3TurboSwitch.dmg`
2. Drag `M3TurboSwitch.app` into `/Applications`
3. Launch once from Applications
4. Grant required permissions/password prompt when Turbo action is first used

Optional local signing:

```bash
CODESIGN_IDENTITY="Apple Development: Your Name (TEAMID)" ./scripts/build_and_package.sh
```

## Current implementation status

This repo currently provides a minimal app shell and packaging pipeline.
To make Turbo switching fully functional, implement the privileged helper path:

- One-time authorization prompt per app session.
- Privileged helper call for Turbo enable/disable.
- Real Turbo status readback.
- Real current CPU temperature read.

See: `docs/implementation-notes.md`.


## How to open it on your Mac

If you already have the repo on your Mac:

```bash
cd /path/to/M3TurboSwitch
./scripts/build_and_package.sh
open build/release/M3TurboSwitch.dmg
```

Then:

1. Drag `M3TurboSwitch.app` to **Applications**.
2. Open **Applications** and launch **M3TurboSwitch**.
3. If macOS blocks first launch: right-click app → **Open** → **Open**.
4. If needed, clear quarantine flag:

```bash
xattr -dr com.apple.quarantine /Applications/M3TurboSwitch.app
```

After launch, the app appears in the menu bar as a bolt icon.


## Troubleshooting: "command not found" for `build_and_package.sh`

If you are already inside the `scripts` folder on your Intel Mac, run:

```bash
chmod +x build_and_package.sh
./build_and_package.sh
```

Do **not** run just `build_and_package.sh` by itself unless `.` is in your PATH.

If it still fails, run it explicitly with bash:

```bash
bash build_and_package.sh
```

If you are at repo root, use:

```bash
./scripts/build_and_package.sh
```


### Error: `unable to lookup item 'platformPath' in sdk`

This means your Xcode/SDK path is not set correctly.

Run:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
xcodebuild -downloadPlatform macOS
```

Then verify:

```bash
xcrun --sdk macosx --show-sdk-platform-path
```

If that prints a valid path, rerun:

```bash
./build_and_package.sh
```


### Error: `invalid developer directory '/Applications/Xcode.app/Contents/Developer'`

That means full Xcode is not installed at that exact path.

Use one of these instead:

```bash
# If you installed full Xcode (or it has a different name/path), switch to its real Developer dir
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# If you only installed Command Line Tools
sudo xcode-select --switch /Library/Developer/CommandLineTools
```

Then verify:

```bash
xcode-select -p
xcrun --sdk macosx --show-sdk-platform-path
```

If you do not have full Xcode yet, install it from the App Store first, open it once, then rerun the commands.
