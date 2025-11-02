# TTSService Class Reference

*File:* `scripts/radio/TTSService.gd`
*Inherits:* `Node`

## Synopsis

```gdscript
extends Node
```

## Brief

Piper CLI streaming bridge using piper_gd.

## Detailed Description

Audio generator buffer length (sec).

## Public Member Functions

- [`func _ready() -> void`](TTSService/functions/_ready.md)
- [`func is_ready() -> bool`](TTSService/functions/is_ready.md) — Check if TTS Service is ready.
- [`func get_stream() -> AudioStreamGenerator`](TTSService/functions/get_stream.md) — Return the current AudioStreamGenerator.
- [`func set_voice(new_model: Model) -> bool`](TTSService/functions/set_voice.md) — Set speaker voice model and restart streaming service.
- [`func register_playback(playback: AudioStreamGeneratorPlayback) -> void`](TTSService/functions/register_playback.md) — Register the consumer's playback so we can push frames into it.
- [`func register_player(player: AudioStreamPlayer) -> void`](TTSService/functions/register_player.md) — Register by passing the player's node (sets stream & plays).
- [`func say(text: String) -> bool`](TTSService/functions/say.md) — Generate a TTS response (async).
- [`func _process(_dt: float) -> void`](TTSService/functions/_process.md) — Pull bytes from the extension and push frames (if playback registered).
- [`func _exit_tree() -> void`](TTSService/functions/_exit_tree.md) — Stop stream thread to avoid hang on exit.
- [`func _read_sample_rate(cfg_res_path: String, fallback: int) -> int`](TTSService/functions/_read_sample_rate.md) — Helper: Read sample rate from model config.
- [`func _get_platform_binary() -> String`](TTSService/functions/_get_platform_binary.md) — Helper: Get platform specific path for piper binary.
- [`func _get_model_path(mdl: Model) -> Dictionary`](TTSService/functions/_get_model_path.md) — Helper: Get path of selected model.
- [`func _abs_path(path: String) -> String`](TTSService/functions/_abs_path.md) — Helper: returns absolute path
`path` res path to translate.

## Public Attributes

- `Model model` — Model to use for voice.
- `AudioStreamGeneratorPlayback _playback`

## Signals

- `signal stream_ready(stream: AudioStreamGenerator)` — Emitted when the streaming daemon is ready.
- `signal stream_error(message: String)` — Emitted on streaming error.
- `signal speaking_started(text: String)` — Emitted when a line is sent to Piper (best-effort).

## Enumerations

- `enum Model` — Available speaker models.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### is_ready

```gdscript
func is_ready() -> bool
```

Check if TTS Service is ready.
[return] True if the Piper streaming process is running.

### get_stream

```gdscript
func get_stream() -> AudioStreamGenerator
```

Return the current AudioStreamGenerator.
[return] current AudioStreamGenerator.

### set_voice

```gdscript
func set_voice(new_model: Model) -> bool
```

Set speaker voice model and restart streaming service.
`new_model` New model to use.
[return] True if model switched, false if failed.

### register_playback

```gdscript
func register_playback(playback: AudioStreamGeneratorPlayback) -> void
```

Register the consumer's playback so we can push frames into it.
`playback` The player's stream playback.

### register_player

```gdscript
func register_player(player: AudioStreamPlayer) -> void
```

Register by passing the player's node (sets stream & plays).
`player` The player to register for playback.

### say

```gdscript
func say(text: String) -> bool
```

Generate a TTS response (async).
`text` The text to speak.
[return] True if speaking started.

### _process

```gdscript
func _process(_dt: float) -> void
```

Pull bytes from the extension and push frames (if playback registered).

### _exit_tree

```gdscript
func _exit_tree() -> void
```

Stop stream thread to avoid hang on exit.

### _read_sample_rate

```gdscript
func _read_sample_rate(cfg_res_path: String, fallback: int) -> int
```

Helper: Read sample rate from model config.
`cfg_res_path` res:// path to model config.
`fallback` Fallback sample rate.
[return] Model sample rate.

### _get_platform_binary

```gdscript
func _get_platform_binary() -> String
```

Helper: Get platform specific path for piper binary.
[return] path to platform specific binary or empty string for unknown.

### _get_model_path

```gdscript
func _get_model_path(mdl: Model) -> Dictionary
```

Helper: Get path of selected model.
`model` a Model enum identifier.
[return] Path to model or empty string for unknown.

### _abs_path

```gdscript
func _abs_path(path: String) -> String
```

Helper: returns absolute path
`path` res path to translate.
[return] Returns absolute path.

## Member Data Documentation

### model

```gdscript
var model: Model
```

Decorators: `@export`

Model to use for voice.

### _playback

```gdscript
var _playback: AudioStreamGeneratorPlayback
```

## Signal Documentation

### stream_ready

```gdscript
signal stream_ready(stream: AudioStreamGenerator)
```

Emitted when the streaming daemon is ready. Receiver should attach this
stream to their own AudioStreamPlayer.

### stream_error

```gdscript
signal stream_error(message: String)
```

Emitted on streaming error.

### speaking_started

```gdscript
signal speaking_started(text: String)
```

Emitted when a line is sent to Piper (best-effort).

## Enumeration Type Documentation

### Model

```gdscript
enum Model
```

Available speaker models.
