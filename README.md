# M3TurboSwitch (Simple Turbo Boost Menu Bar App)

A minimal macOS menu bar app blueprint inspired by Turbo Boost Switcher, focused on only core features:

- Turbo Boost ON/OFF icon in menu bar.
- Enable/disable Turbo Boost manually.
- Optional **Disable Turbo Boost on boot**.
- Optional **Open at Login**.
- Show only **current CPU temperature**.
- No about/help/update UI, no charts, no refresh-rate controls, no hotkeys, no localization, no status text.

## CPU + macOS compatibility

- **CPU targets**: Intel (`x86_64`) and Apple Silicon (`arm64`) via universal build.
- **Minimum macOS target**: Ventura (**13.0+**), including Ventura 13.7.x.
- This means you can build on Apple Silicon and run the same app bundle on Intel Macs.

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
