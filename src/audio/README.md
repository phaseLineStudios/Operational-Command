# audio/
Audio buses and assets for HQ ambience, radio FX, and UI.

## Files
- `buses.tres` — Bus layout asset. Includes a `Capture` bus for mic input and a `Radio` bus for hiss/clicks.

## Subfolders
- `sfx/` — ambience, radio squelch/static, map/tool ticks.
- `ui/` — navigation, button, modal sounds.
- `music/` — background music

## Conventions
- Format: 48 kHz, 16-bit WAV preferred for source; Godot imports to OGG by default.
- Loudness target: peaks ≤ -1 dBFS, integrated LUFS ~ -16 for UI, ~ -20 for ambience.
- Filenames: `category_event_variant.wav` (e.g., `radio_click_up.wav`).

## Implementation
- `Radio.gd` triggers radio FX; `HUD.gd` triggers UI SFX.
