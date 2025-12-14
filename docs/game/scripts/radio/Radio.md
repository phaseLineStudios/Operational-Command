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

Simulated field radio: PTT state, audio FX, and routing to STT.

## Detailed Description

Plays squelch/static, shows UI state, and opens/closes the mic path to the
speech recognizer while PTT is active.

Turn on/off the radio stream

## Public Member Functions

- [`func _ready() -> void`](Radio/functions/_ready.md) — Connect to STTService signals.
- [`func _unhandled_input(event: InputEvent) -> void`](Radio/functions/_unhandled_input.md) — Handle PTT input.
- [`func _on_result(t)`](Radio/functions/_on_result.md) — Temporary for testing
- [`func _start_tx() -> void`](Radio/functions/_start_tx.md) — Manually enable the radio / STT.
- [`func _stop_tx() -> void`](Radio/functions/_stop_tx.md) — Manually disable the radio / STT.
- [`func _exit_tree() -> void`](Radio/functions/_exit_tree.md) — Ensure we stop capture when the radio node leaves.

## Public Attributes

- `OrdersParser parser`
- `UnitVoiceResponses unit_responses` — Reference to unit voice responses controller

## Signals

- `signal radio_on` — Emitted when PTT is pressed (radio transmission starts).
- `signal radio_off` — Emitted when PTT is released (radio transmission ends).
- `signal radio_partial(text: String)` — Emitted during recognition with partial/interim transcription.
- `signal radio_result(text: String)` — Emitted when recognition completes with final transcription.
- `signal radio_raw_command(text: String)` — Emitted with raw command text before parsing (for custom trigger matching).

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

## Member Data Documentation

### parser

```gdscript
var parser: OrdersParser
```

### unit_responses

```gdscript
var unit_responses: UnitVoiceResponses
```

Decorators: `@onready`

Reference to unit voice responses controller

## Signal Documentation

### radio_on

```gdscript
signal radio_on
```

Emitted when PTT is pressed (radio transmission starts).

### radio_off

```gdscript
signal radio_off
```

Emitted when PTT is released (radio transmission ends).

### radio_partial

```gdscript
signal radio_partial(text: String)
```

Emitted during recognition with partial/interim transcription.

### radio_result

```gdscript
signal radio_result(text: String)
```

Emitted when recognition completes with final transcription.

### radio_raw_command

```gdscript
signal radio_raw_command(text: String)
```

Emitted with raw command text before parsing (for custom trigger matching).
Connected to [TriggerEngine] via `method TriggerEngine.bind_radio` to make
text available in trigger conditions via `method TriggerAPI.last_radio_command`.
