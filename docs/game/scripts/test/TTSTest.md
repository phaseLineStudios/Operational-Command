# TTSTest Class Reference

*File:* `scripts/test/TTSTest.gd`
*Class name:* `TTSTest`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name TTSTest
extends Control
```

## Brief

Test TTS Service.

## Public Member Functions

- [`func _ready() -> void`](TTSTest/functions/_ready.md)
- [`func _on_submit() -> void`](TTSTest/functions/_on_submit.md)
- [`func _on_stream_ready(stream: AudioStreamGenerator) -> void`](TTSTest/functions/_on_stream_ready.md)

## Public Attributes

- `OptionButton model_input`
- `TextEdit text_input`
- `Button submit_btn`
- `AudioStreamPlayer radio_player`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _on_submit

```gdscript
func _on_submit() -> void
```

### _on_stream_ready

```gdscript
func _on_stream_ready(stream: AudioStreamGenerator) -> void
```

## Member Data Documentation

### model_input

```gdscript
var model_input: OptionButton
```

### text_input

```gdscript
var text_input: TextEdit
```

### submit_btn

```gdscript
var submit_btn: Button
```

### radio_player

```gdscript
var radio_player: AudioStreamPlayer
```
