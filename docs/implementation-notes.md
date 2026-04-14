# Implementation notes for simple Turbo Boost switcher

This app is intentionally minimal and targets:

- macOS Ventura 13.0+
- Intel (`x86_64`) and Apple Silicon (`arm64`) Macs

## Remaining functional work

1. **Privileged Turbo helper**
   - Provide a helper tool/daemon that can perform Turbo Boost enable/disable.
   - Expose only two actions: `enable`, `disable`.

2. **One password prompt per app session**
   - In `TurboController.requestAuthorizationOnce()`, acquire authorization once.
   - Reuse that authorization while the app is running.

3. **Turbo state detection**
   - In `readTurboStatus()`, query helper state or kernel interface and return on/off.

4. **Current temperature on-demand only**
   - In `TemperatureMonitor`, fetch one CPU temperature reading.
   - Keep this on menu-open / explicit refresh only (no timer).

5. **Boot/login behavior**
   - App launch reads `disableTurboOnBoot` and applies immediately.
   - `openAtLogin` controls whether app starts on user login.

## Distribution

Use `./scripts/build_and_package.sh` on macOS to produce:

- `build/release/M3TurboSwitch.app`
- `build/release/M3TurboSwitch.dmg`

Then distribute the DMG so users can copy the app to `/Applications`.

## Intentionally excluded

- About/help/update windows.
- Charts/history.
- Refresh-interval settings.
- Hotkeys.
- Localization.
- Extra status text in menu bar.
