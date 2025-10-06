# STTService Class Reference

*File:* `scripts/radio/STTService.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Offline speech-to-text capture using Vosk via GDExtension.

## Detailed Description

Captures microphone audio, applies optional VAD, and submits chunks to
vosk_gd. Emits transcription results for parsing into orders.

## Public Member Functions

- [`func _ready() -> void`](STTService/functions/_ready.md)
- [`func start() -> void`](STTService/functions/start.md) — Starts streaming mic audio into Vosk.
- [`func stop() -> void`](STTService/functions/stop.md) — Stops streaming mic audio.
- [`func _process(_dt: float) -> void`](STTService/functions/_process.md) — Pull audio from the capture bus and feed Vosk in small chunks.
- [`func get_final_result() -> String`](STTService/functions/get_final_result.md) — Returns the last final result from the recognizer (non-blocking).
- [`func get_partial() -> String`](STTService/functions/get_partial.md) — Returns the latest partial result from the recognizer (non-blocking).
- [`func _reset_buffers() -> void`](STTService/functions/_reset_buffers.md) — Reset sentence buffers for a new recording session.
- [`func _update_partial_segment(partial_text: String) -> void`](STTService/functions/_update_partial_segment.md) — Update the current segment with a new partial.
- [`func _apply_final(final_text: String) -> void`](STTService/functions/_apply_final.md) — Apply a Vosk final by replacing the current partial segment with final text.
- [`func _emit_partial() -> void`](STTService/functions/_emit_partial.md) — Emit the current accumulated sentence as a partial update.
- [`func _extract_final_text(raw: String) -> String`](STTService/functions/_extract_final_text.md) — Extract final text from Vosk's result(), which may be JSON or plain text.
- [`func _build_full_sentence() -> String`](STTService/functions/_build_full_sentence.md) — Build the visible sentence from committed + segment with single spacing.
- [`func _join_non_empty(a: String, b: String) -> String`](STTService/functions/_join_non_empty.md) — Join a and b with a single space if both are non-empty.

## Public Attributes

- `AudioEffectCapture _effect`
- `Vosk _stt`

## Signals

- `signal partial(text: String)` — Emitted on partial recognition
- `signal result(text: String)` — Emitted on final recognition
- `signal error(msg: String)` — Emitted on setup or runtime errors

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### start

```gdscript
func start() -> void
```

Starts streaming mic audio into Vosk.

### stop

```gdscript
func stop() -> void
```

Stops streaming mic audio.

### _process

```gdscript
func _process(_dt: float) -> void
```

Pull audio from the capture bus and feed Vosk in small chunks.

### get_final_result

```gdscript
func get_final_result() -> String
```

Returns the last final result from the recognizer (non-blocking).

### get_partial

```gdscript
func get_partial() -> String
```

Returns the latest partial result from the recognizer (non-blocking).

### _reset_buffers

```gdscript
func _reset_buffers() -> void
```

Reset sentence buffers for a new recording session.

### _update_partial_segment

```gdscript
func _update_partial_segment(partial_text: String) -> void
```

Update the current segment with a new partial.

### _apply_final

```gdscript
func _apply_final(final_text: String) -> void
```

Apply a Vosk final by replacing the current partial segment with final text.

### _emit_partial

```gdscript
func _emit_partial() -> void
```

Emit the current accumulated sentence as a partial update.

### _extract_final_text

```gdscript
func _extract_final_text(raw: String) -> String
```

Extract final text from Vosk's result(), which may be JSON or plain text.

### _build_full_sentence

```gdscript
func _build_full_sentence() -> String
```

Build the visible sentence from committed + segment with single spacing.

### _join_non_empty

```gdscript
func _join_non_empty(a: String, b: String) -> String
```

Join a and b with a single space if both are non-empty.

## Member Data Documentation

### _effect

```gdscript
var _effect: AudioEffectCapture
```

### _stt

```gdscript
var _stt: Vosk
```

## Signal Documentation

### partial

```gdscript
signal partial(text: String)
```

Emitted on partial recognition

### result

```gdscript
signal result(text: String)
```

Emitted on final recognition

### error

```gdscript
signal error(msg: String)
```

Emitted on setup or runtime errors
