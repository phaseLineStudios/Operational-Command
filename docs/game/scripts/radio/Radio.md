# Radio Class Reference

*File:* `scripts/radio/Radio.gd`
*Class name:* `Radio`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name Radio
extends Node
```

## Brief

Turn on/off the radio stream

## Public Member Functions

- [`func _ready() -> void`](Radio/functions/_ready.md) — Connect to STTService signals.
- [`func _unhandled_input(event: InputEvent) -> void`](Radio/functions/_unhandled_input.md) — Handle PTT input.
- [`func _on_result(t)`](Radio/functions/_on_result.md) — Temporary for testing
- [`func _start_tx() -> void`](Radio/functions/_start_tx.md) — Manually enable the radio / STT.
- [`func _stop_tx() -> void`](Radio/functions/_stop_tx.md) — Manually disable the radio / STT.
- [`func _exit_tree() -> void`](Radio/functions/_exit_tree.md) — Ensure we stop capture when the radio node leaves.

## Signals

- `signal radio_on` — Simulated field radio: PTT state, audio FX, and routing to STT.
- `signal radio_off`
- `signal radio_partial(text: String)`
- `signal radio_result(text: String)`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Connect to STTService signals.

### _unhandled_input

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

Handle PTT input.

### _on_result

```gdscript
func _on_result(t)
```

Temporary for testing
TODO Remove this

### _start_tx

```gdscript
func _start_tx() -> void
```

Manually enable the radio / STT.

### _stop_tx

```gdscript
func _stop_tx() -> void
```

Manually disable the radio / STT.

### _exit_tree

```gdscript
func _exit_tree() -> void
```

Ensure we stop capture when the radio node leaves.

## Signal Documentation

### radio_on

```gdscript
signal radio_on
```

Simulated field radio: PTT state, audio FX, and routing to STT.

Plays squelch/static, shows UI state, and opens/closes the mic path to the
speech recognizer while PTT is active.

### radio_off

```gdscript
signal radio_off
```

### radio_partial

```gdscript
signal radio_partial(text: String)
```

### radio_result

```gdscript
signal radio_result(text: String)
```
