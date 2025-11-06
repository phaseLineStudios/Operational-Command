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

Generates unit voice acknowledgments for orders.

## Detailed Description

Connects to OrdersRouter signals and triggers TTS responses.

Acknowledgment phrases by order type.

## Public Member Functions

- [`func _ready() -> void`](UnitVoiceResponses/functions/_ready.md)
- [`func init(id_index: Dictionary, world: Node, terrain_renderer: Node = null) -> void`](UnitVoiceResponses/functions/init.md) — Initialize with references to units and simulation world.
- [`func _on_order_applied(order: Dictionary) -> void`](UnitVoiceResponses/functions/_on_order_applied.md) — Handle order applied - generate acknowledgment or report.
- [`func _get_acknowledgment(order_type: String) -> String`](UnitVoiceResponses/functions/_get_acknowledgment.md) — Get a random acknowledgment phrase for an order type.
- [`func _get_order_type_name(type: Variant) -> String`](UnitVoiceResponses/functions/_get_order_type_name.md) — Convert order type to string name.
- [`func _handle_report(order: Dictionary, callsign: String, unit_id: String) -> void`](UnitVoiceResponses/functions/_handle_report.md) — Handle report generation based on report type.
- [`func _generate_status_report(unit: ScenarioUnit, callsign: String) -> String`](UnitVoiceResponses/functions/_generate_status_report.md) — Generate status report: unit status, position, and current task.
- [`func _generate_position_report(unit: ScenarioUnit, callsign: String) -> String`](UnitVoiceResponses/functions/_generate_position_report.md) — Generate position report: position, direction if moving, speed if moving.
- [`func _generate_contact_report(unit: ScenarioUnit, callsign: String) -> String`](UnitVoiceResponses/functions/_generate_contact_report.md) — Generate contact report: known hostile elements and their status/positions.
- [`func _get_grid_position(pos_m: Vector2) -> String`](UnitVoiceResponses/functions/_get_grid_position.md) — Get grid coordinate for a position.
- [`func _get_current_task(unit: ScenarioUnit) -> String`](UnitVoiceResponses/functions/_get_current_task.md) — Get current task description for a unit.
- [`func _get_cardinal_direction(from: Vector2, to: Vector2) -> String`](UnitVoiceResponses/functions/_get_cardinal_direction.md) — Get cardinal direction from one position to another.

## Public Attributes

- `tts_service` — Reference to TTS service (autoload).
- `Dictionary units_by_id` — Reference to unit index (unit_id -> ScenarioUnit).
- `SimWorld sim_world` — Reference to SimWorld for contact data.
- `TerrainRender terrain_render` — Reference to terrain renderer for grid conversions.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### init

```gdscript
func init(id_index: Dictionary, world: Node, terrain_renderer: Node = null) -> void
```

Initialize with references to units and simulation world.
`id_index` Dictionary String->ScenarioUnit (by unit id).
`world` Reference to SimWorld for contact data.
`terrain_renderer` Reference to TerrainRender for grid conversions.

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

## Member Data Documentation

### tts_service

```gdscript
var tts_service
```

Reference to TTS service (autoload).

### units_by_id

```gdscript
var units_by_id: Dictionary
```

Reference to unit index (unit_id -> ScenarioUnit).

### sim_world

```gdscript
var sim_world: SimWorld
```

Reference to SimWorld for contact data.

### terrain_render

```gdscript
var terrain_render: TerrainRender
```

Reference to terrain renderer for grid conversions.
