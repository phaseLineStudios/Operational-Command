# Operational Command
Alternate-history Cold War RTS focused on command-post gameplay and voice radio orders.

## Layout
- `docs` — Documentation for the project
- `extras` — Extra assets associated with the project
- `src/` — The main project files
  - `addons/` — GDExtensions, editor plugins (build artifacts live here).
  - `audio/` — bus layout, SFX, UI sounds.
  - `data/` — JSON databases (units, maps, briefs/intel).
  - `maps/` — map imagery and height/feature layers.
  - `scenes/` — .tscn scenes for menus, HQ table, tactical map, etc.
  - `scripts/` — GDScript source (see that folder’s docs).
  - `third_party/` — external models/libs (Vosk, VAD).

## Conventions
- Paths are stable IDs; JSON refers to assets with `id` fields matching filenames.
- All JSON is UTF-8, LF line endings.
