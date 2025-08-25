# addons/
Editor plugins and GDExtension outputs.

## Contents
- `vosk_gd/` — Native extension used by the STT service.

## Notes
- Do not commit platform-specific build artifacts unless they are part of a release.
- Extension binaries should mirror Godot’s expected per-platform layout (`.gdextension` + `.dll/.dylib/.so`).
