# TriggerEngine Class Reference

*File:* `scripts/sim/scenario/TriggerEngine.gd`
*Class name:* `TriggerEngine`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name TriggerEngine
extends Node
```

## Brief

If false, call tick(dt) manually from SimWorld

Count of units in area.

## Detailed Description

`center_m` Center of area
`size_m` Size of area.
`shape` Shape of area (rect or circle).
[return] a dictionary of unit counts.

Check if a given point is withn a shape.
`p` Point to check.
`center_m` Area center.
`size` Area size.
`shape` Area shape.
[return] True if point is inside shape.

Count of units in an area.
`affiliation` Affiliation to filter for.
`center_m` Center of area
`size_m` Size of area.
`shape` Shape of area (rect or circle).
[return] a dictionary of unit counts by affiliation.

Units in an area.
`affiliation` Affiliation to filter for.
`center_m` Center of area
`size_m` Size of area.
`shape` Shape of area (rect or circle).
[return] a dictionary of unit counts by affiliation.

Schedule an action to execute after a delay.
`delay_s` Delay in seconds before execution.
`expr` Expression to execute.
`ctx` Context dictionary for the expression.
`use_realtime` If true, uses real-time instead of mission time.

## Public Member Functions

- [`func _ready() -> void`](TriggerEngine/functions/_ready.md) — Wire API.
- [`func _process(dt: float) -> void`](TriggerEngine/functions/_process.md) — Tick triggers independently and track real-time.
- [`func bind_scenario(scenario: ScenarioData) -> void`](TriggerEngine/functions/bind_scenario.md) — Bind scenario to engine.
- [`func bind_radio(radio: Radio) -> void`](TriggerEngine/functions/bind_radio.md) — Bind radio to listen for raw commands.
- [`func bind_dialog(dialog: Control) -> void`](TriggerEngine/functions/bind_dialog.md) — Bind mission dialog UI for trigger scripts.
- [`func tick(dt: float) -> void`](TriggerEngine/functions/tick.md) — Deterministic evaluation entry point.
- [`func _refresh_unit_indices() -> void`](TriggerEngine/functions/_refresh_unit_indices.md) — Refresh unit indices.
- [`func _evaluate_trigger(t: ScenarioTrigger, dt: float) -> void`](TriggerEngine/functions/_evaluate_trigger.md) — Evaluate a ScenarioTrigger.
- [`func _check_presence(t: ScenarioTrigger) -> bool`](TriggerEngine/functions/_check_presence.md) — Check trigger unit presence.
- [`func _make_ctx(t: ScenarioTrigger, presence_ok: bool) -> Dictionary`](TriggerEngine/functions/_make_ctx.md) — Build a context to pass to trigger eval.
- [`func get_unit_snapshot(id_or_callsign: String) -> Dictionary`](TriggerEngine/functions/get_unit_snapshot.md) — Get a unit snapshot.
- [`func _on_radio_raw(text: String) -> void`](TriggerEngine/functions/_on_radio_raw.md) — Handle raw radio command from Radio node.
- [`func activate_trigger(trigger_id: String) -> bool`](TriggerEngine/functions/activate_trigger.md) — Manually activate a trigger by ID.
- [`func get_global(key: String, default: Variant = null) -> Variant`](TriggerEngine/functions/get_global.md) — Get a global variable value shared across all triggers.
- [`func set_global(key: String, value: Variant) -> void`](TriggerEngine/functions/set_global.md) — Set a global variable value shared across all triggers.
- [`func has_global(key: String) -> bool`](TriggerEngine/functions/has_global.md) — Check if a global variable exists.
- [`func clear_globals() -> void`](TriggerEngine/functions/clear_globals.md) — Clear all global variables.
- [`func execute_expression(expr: String, ctx: Dictionary) -> void`](TriggerEngine/functions/execute_expression.md) — Execute an expression immediately (used by dialog blocking).
- [`func _process_mission_time_actions() -> void`](TriggerEngine/functions/_process_mission_time_actions.md) — Process mission-time scheduled actions that are ready to execute.
- [`func _process_realtime_actions() -> void`](TriggerEngine/functions/_process_realtime_actions.md) — Process real-time scheduled actions that are ready to execute.

## Public Attributes

- `SimWorld _sim` — SimWorld for time and snapshots
- `ScenarioData _scenario`
- `Dictionary _snap_by_id`
- `Dictionary _id_by_callsign`
- `Radio _radio`
- `String _last_radio_text`
- `Dictionary _globals` — Shared global variables accessible across all triggers
- `Array _scheduled_actions` — Scheduled actions queue: [{execute_at: float, expr: String, ctx: Dictionary, use_realtime: bool}]
- `float _realtime_accumulator` — Real-time accumulator for sleep_ui
- `Dictionary s`
- `Vector2 pos`
- `float r`
- `float execute_at`

## Signals

- `signal trigger_activated(trigger_id: String)` — Deterministic evaluator for ScenarioTrigger resources.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Wire API.

### _process

```gdscript
func _process(dt: float) -> void
```

Tick triggers independently and track real-time.

### bind_scenario

```gdscript
func bind_scenario(scenario: ScenarioData) -> void
```

Bind scenario to engine.
`scenario` Current scenario.

### bind_radio

```gdscript
func bind_radio(radio: Radio) -> void
```

Bind radio to listen for raw commands.
Connects to `signal Radio.radio_raw_command` to capture voice input before parsing.
Makes raw text available to triggers via `method TriggerAPI.last_radio_command`.
  
  

**Called automatically by SimWorld.bind_radio().**
`radio` Radio node emitting `signal Radio.radio_raw_command` signal.

### bind_dialog

```gdscript
func bind_dialog(dialog: Control) -> void
```

Bind mission dialog UI for trigger scripts.
Makes dialog available via `method TriggerAPI.show_dialog`.
`dialog` MissionDialog node for displaying trigger messages.

### tick

```gdscript
func tick(dt: float) -> void
```

Deterministic evaluation entry point.
`dt` delta time from last tick.

### _refresh_unit_indices

```gdscript
func _refresh_unit_indices() -> void
```

Refresh unit indices.

### _evaluate_trigger

```gdscript
func _evaluate_trigger(t: ScenarioTrigger, dt: float) -> void
```

Evaluate a ScenarioTrigger.
`t` Trigger to evaluate.
`dt` Delta time since last tick.

### _check_presence

```gdscript
func _check_presence(t: ScenarioTrigger) -> bool
```

Check trigger unit presence.
`t` Trigger to check unit presence on.
[return] True if presence passes.

### _make_ctx

```gdscript
func _make_ctx(t: ScenarioTrigger, presence_ok: bool) -> Dictionary
```

Build a context to pass to trigger eval.
`t` Trigger to create context for.
`presence_ok` Check if presence check is ok.
[return] trigger context.

### get_unit_snapshot

```gdscript
func get_unit_snapshot(id_or_callsign: String) -> Dictionary
```

Get a unit snapshot.
`id_or_callsign` ID or Callsign of unit.
[return] {id, callsign, pos_m: Vector2, aff: int} or {}.

### _on_radio_raw

```gdscript
func _on_radio_raw(text: String) -> void
```

Handle raw radio command from Radio node.

### activate_trigger

```gdscript
func activate_trigger(trigger_id: String) -> bool
```

Manually activate a trigger by ID.
Forces a trigger to become active and run its on_activate expression.
Used by custom voice commands to fire specific triggers.
`trigger_id` ID of the trigger to activate.
[return] True if trigger was found and activated.

### get_global

```gdscript
func get_global(key: String, default: Variant = null) -> Variant
```

Get a global variable value shared across all triggers.
`key` Variable name.
`default` Default value if variable doesn't exist.
[return] Variable value or default.

### set_global

```gdscript
func set_global(key: String, value: Variant) -> void
```

Set a global variable value shared across all triggers.
`key` Variable name.
`value` Value to store.

### has_global

```gdscript
func has_global(key: String) -> bool
```

Check if a global variable exists.
`key` Variable name.
[return] True if variable exists.

### clear_globals

```gdscript
func clear_globals() -> void
```

Clear all global variables.

### execute_expression

```gdscript
func execute_expression(expr: String, ctx: Dictionary) -> void
```

Execute an expression immediately (used by dialog blocking).
`expr` Expression to execute.
`ctx` Context dictionary for the expression.

### _process_mission_time_actions

```gdscript
func _process_mission_time_actions() -> void
```

Process mission-time scheduled actions that are ready to execute.

### _process_realtime_actions

```gdscript
func _process_realtime_actions() -> void
```

Process real-time scheduled actions that are ready to execute.

## Member Data Documentation

### _sim

```gdscript
var _sim: SimWorld
```

Decorators: `@export`

SimWorld for time and snapshots

### _scenario

```gdscript
var _scenario: ScenarioData
```

### _snap_by_id

```gdscript
var _snap_by_id: Dictionary
```

### _id_by_callsign

```gdscript
var _id_by_callsign: Dictionary
```

### _radio

```gdscript
var _radio: Radio
```

### _last_radio_text

```gdscript
var _last_radio_text: String
```

### _globals

```gdscript
var _globals: Dictionary
```

Shared global variables accessible across all triggers

### _scheduled_actions

```gdscript
var _scheduled_actions: Array
```

Scheduled actions queue: [{execute_at: float, expr: String, ctx: Dictionary, use_realtime: bool}]

### _realtime_accumulator

```gdscript
var _realtime_accumulator: float
```

Real-time accumulator for sleep_ui

### s

```gdscript
var s: Dictionary
```

### pos

```gdscript
var pos: Vector2
```

### r

```gdscript
var r: float
```

### execute_at

```gdscript
var execute_at: float
```

## Signal Documentation

### trigger_activated

```gdscript
signal trigger_activated(trigger_id: String)
```

Deterministic evaluator for ScenarioTrigger resources.
Combines presence checks with a sandboxed condition VM and executes actions.
