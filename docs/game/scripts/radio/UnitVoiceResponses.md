# UnitVoiceResponses Class Reference

*File:* `scripts/radio/UnitVoiceResponses.gd`
*Class name:* `UnitVoiceResponses`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name UnitVoiceResponses
extends Node
```

## Brief

Main controller for unit voice responses.

## Detailed Description

Manages both manual acknowledgments (order responses) and automatic responses
(simulation events). Emits transmission signals for sound effect integration.

Path to acknowledgments data file.

Initialize with references to units and simulation world.
`id_index` Dictionary String->ScenarioUnit (by unit id).
`world` Reference to SimWorld for contact data.
`terrain_renderer` Reference to TerrainRender for grid conversions.
`counter_controller` UnitCounterController for spawning counters.
`artillery_controller` ArtilleryController for fire mission responses.

## Public Member Functions

- [`func _ready() -> void`](UnitVoiceResponses/functions/_ready.md)
- [`func _load_acknowledgments() -> void`](UnitVoiceResponses/functions/_load_acknowledgments.md) — Load acknowledgment phrases from JSON data file.
- [`func _on_order_applied(order: Dictionary) -> void`](UnitVoiceResponses/functions/_on_order_applied.md) — Handle order applied - generate acknowledgment or report.
- [`func _get_acknowledgment(order_type: String) -> String`](UnitVoiceResponses/functions/_get_acknowledgment.md) — Get a random acknowledgment phrase for an order type.
- [`func _get_order_type_name(type: Variant) -> String`](UnitVoiceResponses/functions/_get_order_type_name.md) — Convert order type to string name.
- [`func _handle_report(order: Dictionary, callsign: String, unit_id: String) -> void`](UnitVoiceResponses/functions/_handle_report.md) — Handle report generation based on report type.
- [`func _generate_status_report(unit: ScenarioUnit, callsign: String) -> String`](UnitVoiceResponses/functions/_generate_status_report.md) — Generate status report: unit status, position, and current task.
- [`func _generate_position_report(unit: ScenarioUnit, callsign: String) -> String`](UnitVoiceResponses/functions/_generate_position_report.md) — Generate position report: position, direction if moving, speed if moving.
- [`func _generate_contact_report(unit: ScenarioUnit, callsign: String) -> String`](UnitVoiceResponses/functions/_generate_contact_report.md) — Generate contact report: known hostile elements and their status/positions.
- [`func _generate_supply_report(unit: ScenarioUnit, callsign: String) -> String`](UnitVoiceResponses/functions/_generate_supply_report.md) — Generate supply report: ammunition and fuel status.
- [`func _get_grid_position(pos_m: Vector2) -> String`](UnitVoiceResponses/functions/_get_grid_position.md) — Get grid coordinate for a position.
- [`func _get_current_task(unit: ScenarioUnit) -> String`](UnitVoiceResponses/functions/_get_current_task.md) — Get current task description for a unit.
- [`func _get_cardinal_direction(from: Vector2, to: Vector2) -> String`](UnitVoiceResponses/functions/_get_cardinal_direction.md) — Get cardinal direction from one position to another.
- [`func _on_auto_response(callsign: String, message: String) -> void`](UnitVoiceResponses/functions/_on_auto_response.md) — Handle automatic voice response from UnitAutoResponses.
- [`func _on_auto_transmission_start(callsign: String) -> void`](UnitVoiceResponses/functions/_on_auto_transmission_start.md) — Handle transmission start from auto responses.
- [`func _on_auto_transmission_end_requested(_callsign: String) -> void`](UnitVoiceResponses/functions/_on_auto_transmission_end_requested.md) — Handle transmission end request from auto responses.
- [`func _on_tts_finished() -> void`](UnitVoiceResponses/functions/_on_tts_finished.md) — Handle TTS audio playback finished.
- [`func emit_system_message(message: String, callsign: String = "Mission Control") -> void`](UnitVoiceResponses/functions/emit_system_message.md) — Emit a system message (e.g., from TriggerAPI) with radio SFX.

## Public Attributes

- `Dictionary acknowledgments`
- `Dictionary units_by_id`
- `SimWorld sim_world`
- `TerrainRender terrain_render`
- `String _current_transmitter`
- `UnitAutoResponses auto_responses` — Reference to auto responses controller.

## Signals

- `signal unit_response(callsign: String, message: String)` — Emitted when a unit generates a voice response.
- `signal transmission_start(callsign: String)` — Emitted when a unit starts transmitting on radio.
- `signal transmission_end(callsign: String)` — Emitted when a unit finishes transmitting on radio.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _load_acknowledgments

```gdscript
func _load_acknowledgments() -> void
```

Load acknowledgment phrases from JSON data file.

### _on_order_applied

```gdscript
func _on_order_applied(order: Dictionary) -> void
```

Handle order applied - generate acknowledgment or report.
`order` Order dictionary from OrdersRouter.

### _get_acknowledgment

```gdscript
func _get_acknowledgment(order_type: String) -> String
```

Get a random acknowledgment phrase for an order type.
`order_type` Order type string (MOVE, ATTACK, etc.).
[return] Random acknowledgment phrase.

### _get_order_type_name

```gdscript
func _get_order_type_name(type: Variant) -> String
```

Convert order type to string name.
`type` Order type (int or string).
[return] Order type name string.

### _handle_report

```gdscript
func _handle_report(order: Dictionary, callsign: String, unit_id: String) -> void
```

Handle report generation based on report type.
`order` Order dictionary with report_type field.
`callsign` Unit callsign.
`unit_id` Unit ID.

### _generate_status_report

```gdscript
func _generate_status_report(unit: ScenarioUnit, callsign: String) -> String
```

Generate status report: unit status, position, and current task.
`unit` ScenarioUnit to report on.
`callsign` Unit callsign.
[return] Status report string.

### _generate_position_report

```gdscript
func _generate_position_report(unit: ScenarioUnit, callsign: String) -> String
```

Generate position report: position, direction if moving, speed if moving.
`unit` ScenarioUnit to report on.
`callsign` Unit callsign.
[return] Position report string.

### _generate_contact_report

```gdscript
func _generate_contact_report(unit: ScenarioUnit, callsign: String) -> String
```

Generate contact report: known hostile elements and their status/positions.
`unit` ScenarioUnit to report on.
`callsign` Unit callsign.
[return] Contact report string.

### _generate_supply_report

```gdscript
func _generate_supply_report(unit: ScenarioUnit, callsign: String) -> String
```

Generate supply report: ammunition and fuel status.
`unit` ScenarioUnit to report on.
`callsign` Unit callsign.
[return] Supply report string.

### _get_grid_position

```gdscript
func _get_grid_position(pos_m: Vector2) -> String
```

Get grid coordinate for a position.
`pos_m` Position in meters.
[return] Grid coordinate string (e.g. "123456") or empty if unavailable.

### _get_current_task

```gdscript
func _get_current_task(unit: ScenarioUnit) -> String
```

Get current task description for a unit.
`unit` ScenarioUnit to check.
[return] Task description string or empty if none.

### _get_cardinal_direction

```gdscript
func _get_cardinal_direction(from: Vector2, to: Vector2) -> String
```

Get cardinal direction from one position to another.
`from` Start position.
`to` End position.
[return] Cardinal direction string (e.g., "north", "northeast").

### _on_auto_response

```gdscript
func _on_auto_response(callsign: String, message: String) -> void
```

Handle automatic voice response from UnitAutoResponses.
Re-emits as a unit_response for logging/transcript.
`callsign` Unit callsign.
`message` Response message.

### _on_auto_transmission_start

```gdscript
func _on_auto_transmission_start(callsign: String) -> void
```

Handle transmission start from auto responses.
`callsign` Unit callsign.

### _on_auto_transmission_end_requested

```gdscript
func _on_auto_transmission_end_requested(_callsign: String) -> void
```

Handle transmission end request from auto responses.
Doesn't emit immediately - waits for TTS to finish.
`callsign` Unit callsign.

### _on_tts_finished

```gdscript
func _on_tts_finished() -> void
```

Handle TTS audio playback finished.
Emits transmission_end for the current transmitter.

### emit_system_message

```gdscript
func emit_system_message(message: String, callsign: String = "Mission Control") -> void
```

Emit a system message (e.g., from TriggerAPI) with radio SFX.
`message` Message text to speak.
`callsign` Optional callsign (defaults to "Mission Control").

## Member Data Documentation

### acknowledgments

```gdscript
var acknowledgments: Dictionary
```

### units_by_id

```gdscript
var units_by_id: Dictionary
```

### sim_world

```gdscript
var sim_world: SimWorld
```

### terrain_render

```gdscript
var terrain_render: TerrainRender
```

### _current_transmitter

```gdscript
var _current_transmitter: String
```

### auto_responses

```gdscript
var auto_responses: UnitAutoResponses
```

Decorators: `@onready`

Reference to auto responses controller.

## Signal Documentation

### unit_response

```gdscript
signal unit_response(callsign: String, message: String)
```

Emitted when a unit generates a voice response.
`callsign` The unit's callsign.
`message` The full message text.

### transmission_start

```gdscript
signal transmission_start(callsign: String)
```

Emitted when a unit starts transmitting on radio.
`callsign` The unit's callsign.

### transmission_end

```gdscript
signal transmission_end(callsign: String)
```

Emitted when a unit finishes transmitting on radio.
`callsign` The unit's callsign.
