# UnitAutoResponses Class Reference

*File:* `scripts/radio/UnitAutoResponses.gd`
*Class name:* `UnitAutoResponses`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name UnitAutoResponses
extends Node
```

## Brief

Generates automatic unit voice responses for simulation events.

## Detailed Description

Monitors unit state changes and generates contextual voice reports like:
- "Contact spotted!" when enemy units detected
- "Position reached" when arriving at destination
- "Taking fire!" when under attack
- etc.

Event types that trigger voice responses

Voice message in the queue

Event configuration - defines phrases and cooldowns for each event type

Mapping of order failure reasons to specific response phrases

Mapping of movement blocked reasons to specific response phrases

Initialize with simulation world reference.
`sim_world` SimWorld instance.
`units_by_id` Dictionary mapping unit_id to unit data.
`terrain_render` TerrainRender for position to grid conversion.
`counter_controller` UnitCounterController for spawning counters.
`artillery_controller` ArtilleryController for fire mission voice responses.

Queue a message with custom text (bypasses phrase selection).
`unit_id` Unit ID.
`callsign` Unit callsign.
`text` Custom message text.
`priority` Message priority.

Handle engagement reported signal.

Handle artillery mission confirmation.
`unit_id` Artillery unit ID.
`_target_pos` Target position in terrain meters.
`_ammo_type` Ammunition type (e.g., "MORTAR_AP").
`_rounds` Number of rounds.

Handle rounds shot ("Shot" call).
`unit_id` Artillery unit ID.
`_target_pos` Target position in terrain meters.
`_ammo_type` Ammunition type.
`_rounds` Number of rounds.

Handle rounds splash warning (5s before impact).
`unit_id` Artillery unit ID.
`_target_pos` Target position in terrain meters.
`_ammo_type` Ammunition type.
`_rounds` Number of rounds.

Handle rounds impact.
`unit_id` Artillery unit ID.
`_target_pos` Target position in terrain meters.
`_ammo_type` Ammunition type.
`_rounds` Number of rounds.
`_damage` Total damage dealt.

Handle battle damage assessment from observer.
`observer_id` Observer unit ID.
`target_pos` Impact position in terrain meters.
`description` BDA description text.

## Public Member Functions

- [`func _ready() -> void`](UnitAutoResponses/functions/_ready.md)
- [`func _build_callsign_mapping() -> void`](UnitAutoResponses/functions/_build_callsign_mapping.md) — Build callsign mapping from units dictionary.
- [`func _connect_unit_signals() -> void`](UnitAutoResponses/functions/_connect_unit_signals.md) — Connect to unit-specific signals (move_blocked, etc.)
- [`func _connect_artillery_signals() -> void`](UnitAutoResponses/functions/_connect_artillery_signals.md) — Connect to artillery controller signals.
- [`func _process(delta: float) -> void`](UnitAutoResponses/functions/_process.md)
- [`func _process_message_queue(_delta: float) -> void`](UnitAutoResponses/functions/_process_message_queue.md) — Process and emit queued voice messages.
- [`func _compare_messages(a: VoiceMessage, b: VoiceMessage) -> bool`](UnitAutoResponses/functions/_compare_messages.md) — Compare messages for priority sorting (higher priority first).
- [`func _emit_voice_message(msg: VoiceMessage) -> void`](UnitAutoResponses/functions/_emit_voice_message.md) — Emit voice message via TTSService.
- [`func _queue_message(unit_id: String, event_type: EventType) -> void`](UnitAutoResponses/functions/_queue_message.md) — Queue a voice message for a unit.
- [`func _on_unit_updated(unit_id: String, snapshot: Dictionary) -> void`](UnitAutoResponses/functions/_on_unit_updated.md) — Handle unit state update - detect state changes.
- [`func _check_movement_state(unit_id: String, prev: Dictionary, current: Dictionary) -> void`](UnitAutoResponses/functions/_check_movement_state.md) — Check for movement state changes.
- [`func _check_contact_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void`](UnitAutoResponses/functions/_check_contact_changes.md) — Check for contact changes (enemies spotted/lost).
- [`func _on_contact_reported(attacker_id: String, defender_id: String) -> void`](UnitAutoResponses/functions/_on_contact_reported.md) — Handle contact reported signal.
- [`func _on_order_failed(order: Dictionary, reason: String) -> void`](UnitAutoResponses/functions/_on_order_failed.md) — Handle order failure.
- [`func _on_unit_move_blocked(reason: String, unit_id: String) -> void`](UnitAutoResponses/functions/_on_unit_move_blocked.md) — Handle unit move_blocked signal.
- [`func trigger_ammo_low(unit_id: String) -> void`](UnitAutoResponses/functions/trigger_ammo_low.md) — Trigger ammo low event for unit.
- [`func trigger_ammo_critical(unit_id: String) -> void`](UnitAutoResponses/functions/trigger_ammo_critical.md) — Trigger ammo critical event for unit.
- [`func trigger_fuel_low(unit_id: String) -> void`](UnitAutoResponses/functions/trigger_fuel_low.md) — Trigger fuel low event for unit.
- [`func trigger_fuel_critical(unit_id: String) -> void`](UnitAutoResponses/functions/trigger_fuel_critical.md) — Trigger fuel critical event for unit.
- [`func trigger_movement_blocked(unit_id: String, reason: String) -> void`](UnitAutoResponses/functions/trigger_movement_blocked.md) — Handle movement blocked event.
- [`func _report_contact_spotted(spotter_id: String, contact_id: String) -> void`](UnitAutoResponses/functions/_report_contact_spotted.md) — Generate and queue descriptive contact report.
- [`func _get_unit_description(unit: ScenarioUnit) -> String`](UnitAutoResponses/functions/_get_unit_description.md) — Get descriptive text for a unit (e.g., "Enemy infantry platoon").
- [`func _get_grid_from_position(pos_m: Vector2) -> String`](UnitAutoResponses/functions/_get_grid_from_position.md) — Get grid coordinate from terrain position.
- [`func _spawn_contact_counter(contact_id: String) -> void`](UnitAutoResponses/functions/_spawn_contact_counter.md) — Spawn a unit counter for a spotted contact.
- [`func _parse_unit_affiliation(aff: ScenarioUnit.Affiliation) -> MilSymbol.UnitAffiliation`](UnitAutoResponses/functions/_parse_unit_affiliation.md) — parses `enum ScenarioUnit.Affiliation` to `enum MilSymbol.UnitAffiliation`.

## Public Attributes

- `String unit_id`
- `String callsign`
- `String text`
- `Priority priority`
- `float timestamp`
- `int max_queue_size` — Maximum messages in queue
- `float per_unit_cooldown_s` — Minimum time between messages from same unit (seconds)
- `float global_cooldown_s` — Minimum time between any voice messages (seconds)
- `Node _sim_world`
- `Dictionary _units_by_id`
- `Dictionary _id_to_callsign`
- `TerrainRender _terrain_render`
- `UnitCounterController _counter_controller`
- `ArtilleryController _artillery_controller`
- `Dictionary _unit_states`
- `Dictionary _spotted_contacts`
- `Array[VoiceMessage] _message_queue`
- `float _last_message_time`
- `Dictionary _unit_last_message`
- `Dictionary _event_last_triggered`
- `String observer_callsign`

## Signals

- `signal unit_auto_response(callsign: String, message: String)` — Emitted when a unit generates an automatic voice response.

## Enumerations

- `enum Priority` — Voice message priority levels

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _build_callsign_mapping

```gdscript
func _build_callsign_mapping() -> void
```

Build callsign mapping from units dictionary.

### _connect_unit_signals

```gdscript
func _connect_unit_signals() -> void
```

Connect to unit-specific signals (move_blocked, etc.)

### _connect_artillery_signals

```gdscript
func _connect_artillery_signals() -> void
```

Connect to artillery controller signals.

### _process

```gdscript
func _process(delta: float) -> void
```

### _process_message_queue

```gdscript
func _process_message_queue(_delta: float) -> void
```

Process and emit queued voice messages.

### _compare_messages

```gdscript
func _compare_messages(a: VoiceMessage, b: VoiceMessage) -> bool
```

Compare messages for priority sorting (higher priority first).

### _emit_voice_message

```gdscript
func _emit_voice_message(msg: VoiceMessage) -> void
```

Emit voice message via TTSService.

### _queue_message

```gdscript
func _queue_message(unit_id: String, event_type: EventType) -> void
```

Queue a voice message for a unit.

### _on_unit_updated

```gdscript
func _on_unit_updated(unit_id: String, snapshot: Dictionary) -> void
```

Handle unit state update - detect state changes.

### _check_movement_state

```gdscript
func _check_movement_state(unit_id: String, prev: Dictionary, current: Dictionary) -> void
```

Check for movement state changes.

### _check_contact_changes

```gdscript
func _check_contact_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void
```

Check for contact changes (enemies spotted/lost).

### _on_contact_reported

```gdscript
func _on_contact_reported(attacker_id: String, defender_id: String) -> void
```

Handle contact reported signal.

### _on_order_failed

```gdscript
func _on_order_failed(order: Dictionary, reason: String) -> void
```

Handle order failure.
`order` Order dictionary that failed.
`reason` Failure reason code.

### _on_unit_move_blocked

```gdscript
func _on_unit_move_blocked(reason: String, unit_id: String) -> void
```

Handle unit move_blocked signal.
`reason` Block reason code from ScenarioUnit.
`unit_id` Unit ID (bound parameter).

### trigger_ammo_low

```gdscript
func trigger_ammo_low(unit_id: String) -> void
```

Trigger ammo low event for unit.
`unit_id` Unit experiencing low ammo.

### trigger_ammo_critical

```gdscript
func trigger_ammo_critical(unit_id: String) -> void
```

Trigger ammo critical event for unit.
`unit_id` Unit experiencing critical ammo.

### trigger_fuel_low

```gdscript
func trigger_fuel_low(unit_id: String) -> void
```

Trigger fuel low event for unit.
`unit_id` Unit experiencing low fuel.

### trigger_fuel_critical

```gdscript
func trigger_fuel_critical(unit_id: String) -> void
```

Trigger fuel critical event for unit.
`unit_id` Unit experiencing critical fuel.

### trigger_movement_blocked

```gdscript
func trigger_movement_blocked(unit_id: String, reason: String) -> void
```

Handle movement blocked event.
`unit_id` Unit that is blocked.
`reason` Block reason code.

### _report_contact_spotted

```gdscript
func _report_contact_spotted(spotter_id: String, contact_id: String) -> void
```

Generate and queue descriptive contact report.
`spotter_id` Unit that spotted the contact.
`contact_id` Enemy unit that was spotted.

### _get_unit_description

```gdscript
func _get_unit_description(unit: ScenarioUnit) -> String
```

Get descriptive text for a unit (e.g., "Enemy infantry platoon").
`unit` Unit data.
[return] Description string.

### _get_grid_from_position

```gdscript
func _get_grid_from_position(pos_m: Vector2) -> String
```

Get grid coordinate from terrain position.
`pos_m` Position in terrain meters.
[return] Grid string (e.g., "A5").

### _spawn_contact_counter

```gdscript
func _spawn_contact_counter(contact_id: String) -> void
```

Spawn a unit counter for a spotted contact.
`contact_id` Enemy unit ID to spawn counter for.

### _parse_unit_affiliation

```gdscript
func _parse_unit_affiliation(aff: ScenarioUnit.Affiliation) -> MilSymbol.UnitAffiliation
```

parses `enum ScenarioUnit.Affiliation` to `enum MilSymbol.UnitAffiliation`.
`aff` `enum ScenarioUnit.Affiliation` to parse.
[return] parsed `enum MilSymbol.UnitAffiliation`.

## Member Data Documentation

### unit_id

```gdscript
var unit_id: String
```

### callsign

```gdscript
var callsign: String
```

### text

```gdscript
var text: String
```

### priority

```gdscript
var priority: Priority
```

### timestamp

```gdscript
var timestamp: float
```

### max_queue_size

```gdscript
var max_queue_size: int
```

Decorators: `@export`

Maximum messages in queue

### per_unit_cooldown_s

```gdscript
var per_unit_cooldown_s: float
```

Decorators: `@export`

Minimum time between messages from same unit (seconds)

### global_cooldown_s

```gdscript
var global_cooldown_s: float
```

Decorators: `@export`

Minimum time between any voice messages (seconds)

### _sim_world

```gdscript
var _sim_world: Node
```

### _units_by_id

```gdscript
var _units_by_id: Dictionary
```

### _id_to_callsign

```gdscript
var _id_to_callsign: Dictionary
```

### _terrain_render

```gdscript
var _terrain_render: TerrainRender
```

### _counter_controller

```gdscript
var _counter_controller: UnitCounterController
```

### _artillery_controller

```gdscript
var _artillery_controller: ArtilleryController
```

### _unit_states

```gdscript
var _unit_states: Dictionary
```

### _spotted_contacts

```gdscript
var _spotted_contacts: Dictionary
```

### _message_queue

```gdscript
var _message_queue: Array[VoiceMessage]
```

### _last_message_time

```gdscript
var _last_message_time: float
```

### _unit_last_message

```gdscript
var _unit_last_message: Dictionary
```

### _event_last_triggered

```gdscript
var _event_last_triggered: Dictionary
```

### observer_callsign

```gdscript
var observer_callsign: String
```

## Signal Documentation

### unit_auto_response

```gdscript
signal unit_auto_response(callsign: String, message: String)
```

Emitted when a unit generates an automatic voice response.
`callsign` The unit's callsign.
`message` The full message text.

## Enumeration Type Documentation

### Priority

```gdscript
enum Priority
```

Voice message priority levels
