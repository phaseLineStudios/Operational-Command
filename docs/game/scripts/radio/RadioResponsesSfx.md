# RadioResponsesSfx Class Reference

*File:* `scripts/radio/RadioSfx.gd`
*Class name:* `RadioResponsesSfx`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name RadioResponsesSfx
extends Node
```

## Public Member Functions

- [`func _ready() -> void`](RadioResponsesSfx/functions/_ready.md)
- [`func _on_transmission_start(_callsign: String) -> void`](RadioResponsesSfx/functions/_on_transmission_start.md)
- [`func _on_transmission_end(_callsign: String) -> void`](RadioResponsesSfx/functions/_on_transmission_end.md)

## Public Attributes

- `UnitVoiceResponses unit_responses_node` — Unit Voice Responses node.
- `AudioStream transmission_start_sound` — Sound to play at the start of the transmission
- `AudioStream transmission_noise_sound` — Sound to play during the transmission
- `AudioStream transmission_end_sound` — Sound to play at the end of the transmission
- `AudioStreamPlayer3D noise_player`
- `AudioStreamPlayer3D trigger_player`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _on_transmission_start

```gdscript
func _on_transmission_start(_callsign: String) -> void
```

### _on_transmission_end

```gdscript
func _on_transmission_end(_callsign: String) -> void
```

## Member Data Documentation

### unit_responses_node

```gdscript
var unit_responses_node: UnitVoiceResponses
```

Decorators: `@export`

Unit Voice Responses node.

### transmission_start_sound

```gdscript
var transmission_start_sound: AudioStream
```

Decorators: `@export`

Sound to play at the start of the transmission

### transmission_noise_sound

```gdscript
var transmission_noise_sound: AudioStream
```

Decorators: `@export`

Sound to play during the transmission

### transmission_end_sound

```gdscript
var transmission_end_sound: AudioStream
```

Decorators: `@export`

Sound to play at the end of the transmission

### noise_player

```gdscript
var noise_player: AudioStreamPlayer3D
```

### trigger_player

```gdscript
var trigger_player: AudioStreamPlayer3D
```
