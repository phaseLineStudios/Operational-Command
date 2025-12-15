# TriggerAPI Class Reference

*File:* `scripts/sim/scenario/TriggerAPI.gd`
*Class name:* `TriggerAPI`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name TriggerAPI
extends RefCounted
```

## Brief

Count units in an area by affiliation: "friend"|"enemy"|"player"|"any".

## Detailed Description

`affiliation` Unit affiliation.
`center_m` Center of area.
`size_m` Size of area.
`shape` Shape of area (default "rect").
[return] Amount of filtered units in area as int.

Return an Array of unit snapshots in an area.
`affiliation` Unit affiliation.
`center_m` Center of area.
`size_m` Size of area.
`shape` Shape of area (default "rect").
[return] Array of filtered units in area

Show a mission dialog with text and an OK button.
Optionally pauses the simulation until the player dismisses the dialog.
Can display a line from the dialog to a position on the map.
`text` Dialog text to display (supports BBCode formatting)
`pause_game` If true, pauses simulation until dialog is dismissed
`position_m` Optional position on map (in meters) to draw a line to
`block` If true, blocks trigger execution until dialog is closed

Handle artillery mission confirmed signal (internal).

## Public Member Functions

- [`func time_s() -> float`](TriggerAPI/functions/time_s.md) — Return mission time in seconds.
- [`func is_paused() -> bool`](TriggerAPI/functions/is_paused.md) — Check if simulation is paused.
- [`func is_running() -> bool`](TriggerAPI/functions/is_running.md) — Check if simulation is running.
- [`func time_scale() -> float`](TriggerAPI/functions/time_scale.md) — Get current time scale (1.0 = normal, 2.0 = 2x speed).
- [`func sim_state() -> String`](TriggerAPI/functions/sim_state.md) — Get simulation state as string ("INIT", "RUNNING", "PAUSED", "COMPLETED").
- [`func radio(msg: String, level: String = "info", unit_say: String = "") -> void`](TriggerAPI/functions/radio.md) — Send a radio/log message (levels: info|warn|error).
- [`func complete_objective(id: StringName) -> void`](TriggerAPI/functions/complete_objective.md) — Set objective state to completed.
- [`func fail_objective(id: StringName) -> void`](TriggerAPI/functions/fail_objective.md) — Set objective state to failed.
- [`func set_objective(id: StringName, state: int) -> void`](TriggerAPI/functions/set_objective.md) — Set objective state
`id` Objective ID.
- [`func objective_state(id: StringName) -> int`](TriggerAPI/functions/objective_state.md) — Get current objective state via summary payload.
- [`func unit(id_or_callsign: String) -> Dictionary`](TriggerAPI/functions/unit.md) — Minimal snapshot of a unit by id or callsign.
- [`func find_callsign_by_role(role: String) -> String`](TriggerAPI/functions/find_callsign_by_role.md) — Find callsign of first playable unit with the specified role.
- [`func last_radio_command() -> String`](TriggerAPI/functions/last_radio_command.md) — Get the last radio command heard this tick (cleared after tick).
- [`func _set_last_radio_command(cmd: String) -> void`](TriggerAPI/functions/_set_last_radio_command.md) — Internal: Set the last radio command (called by TriggerEngine).
- [`func get_global(key: String, default: Variant = null) -> Variant`](TriggerAPI/functions/get_global.md) — Get a global variable shared across all triggers.
- [`func set_global(key: String, value: Variant) -> void`](TriggerAPI/functions/set_global.md) — Set a global variable shared across all triggers.
- [`func has_global(key: String) -> bool`](TriggerAPI/functions/has_global.md) — Check if a global variable exists.
- [`func triggering_units_friend() -> Array`](TriggerAPI/functions/triggering_units_friend.md) — Get list of friendly unit IDs currently inside the trigger area.
- [`func triggering_units_enemy() -> Array`](TriggerAPI/functions/triggering_units_enemy.md) — Get list of enemy unit IDs currently inside the trigger area.
- [`func triggering_units_player() -> Array`](TriggerAPI/functions/triggering_units_player.md) — Get list of player-controlled unit IDs currently inside the trigger area.
- [`func triggering_unit_friend() -> String`](TriggerAPI/functions/triggering_unit_friend.md) — Get the first friendly unit ID that triggered this area (convenience method).
- [`func triggering_unit_enemy() -> String`](TriggerAPI/functions/triggering_unit_enemy.md) — Get the first enemy unit ID that triggered this area (convenience method).
- [`func triggering_unit_player() -> String`](TriggerAPI/functions/triggering_unit_player.md) — Get the first player-controlled unit ID that triggered this area (convenience method).
- [`func is_unit_in_trigger_area(callsign: String) -> bool`](TriggerAPI/functions/is_unit_in_trigger_area.md) — Check if a specific unit is currently inside the trigger area.
- [`func tutorial_dialog(text: String, node_identifier: String = "", block: bool = true) -> void`](TriggerAPI/functions/tutorial_dialog.md) — Show a tutorial dialog with a line pointing to a UI element.
- [`func has_drawn() -> bool`](TriggerAPI/functions/has_drawn.md) — Check if the player has drawn anything on the map.
- [`func get_drawing_count() -> int`](TriggerAPI/functions/get_drawing_count.md) — Get the number of drawing strokes the player has made.
- [`func has_created_counter() -> bool`](TriggerAPI/functions/has_created_counter.md) — Check if the player has created any unit counters.
- [`func get_counter_count() -> int`](TriggerAPI/functions/get_counter_count.md) — Get the number of unit counters the player has created.
- [`func is_unit_in_combat(id_or_callsign: String) -> bool`](TriggerAPI/functions/is_unit_in_combat.md) — Check if a unit is currently in combat (has spotted enemies).
- [`func get_unit_position(id_or_callsign: String) -> Variant`](TriggerAPI/functions/get_unit_position.md) — Get the current position of a unit in terrain meters (Vector2).
- [`func get_unit_grid(id_or_callsign: String, digits: int = 6) -> String`](TriggerAPI/functions/get_unit_grid.md) — Get the current grid position of a unit (e.g., "630852").
- [`func is_unit_destroyed(id_or_callsign: String) -> bool`](TriggerAPI/functions/is_unit_destroyed.md) — Check if a unit is destroyed (wiped out, state_strength == 0).
- [`func get_unit_strength(id_or_callsign: String) -> float`](TriggerAPI/functions/get_unit_strength.md) — Get the current strength of a unit.
- [`func set_unit_fuel(id_or_callsign: String, fuel_pct: float) -> bool`](TriggerAPI/functions/set_unit_fuel.md) — Set the fuel level of a unit (for scripted events and tutorials).
- [`func has_built_bridge() -> bool`](TriggerAPI/functions/has_built_bridge.md) — Check if any engineers have built a bridge.
- [`func get_bridges_built() -> int`](TriggerAPI/functions/get_bridges_built.md) — Get the number of bridges built by engineers.
- [`func has_called_artillery() -> bool`](TriggerAPI/functions/has_called_artillery.md) — Check if any artillery fire missions have been called.
- [`func get_artillery_calls() -> int`](TriggerAPI/functions/get_artillery_calls.md) — Get the number of artillery fire missions called.
- [`func vec2(x: float, y: float) -> Vector2`](TriggerAPI/functions/vec2.md) — Create a Vector2 from x and y coordinates.
- [`func vec3(x: float, y: float, z: float) -> Vector3`](TriggerAPI/functions/vec3.md) — Create a Vector3 from x, y, and z coordinates.
- [`func color(r: float, g: float, b: float, a: float = 1.0) -> Color`](TriggerAPI/functions/color.md) — Create a Color from RGB or RGBA values (0.0 to 1.0).
- [`func rect2(x: float, y: float, width: float, height: float) -> Rect2`](TriggerAPI/functions/rect2.md) — Create a Rect2 from position and size.
- [`func sleep(duration_s: float) -> void`](TriggerAPI/functions/sleep.md) — Pause execution for a duration (mission time).
- [`func sleep_ui(duration_s: float) -> void`](TriggerAPI/functions/sleep_ui.md) — Pause execution for a duration (real-time).
- [`func _is_sleep_requested() -> bool`](TriggerAPI/functions/_is_sleep_requested.md) — Check if sleep was requested (internal use by TriggerVM).
- [`func _get_sleep_duration() -> float`](TriggerAPI/functions/_get_sleep_duration.md) — Get sleep duration (internal use by TriggerVM).
- [`func _is_sleep_realtime() -> bool`](TriggerAPI/functions/_is_sleep_realtime.md) — Check if sleep uses realtime (internal use by TriggerVM).
- [`func _reset_sleep() -> void`](TriggerAPI/functions/_reset_sleep.md) — Reset sleep state (internal use by TriggerVM).
- [`func _is_dialog_blocking() -> bool`](TriggerAPI/functions/_is_dialog_blocking.md) — Check if dialog blocking is active (internal use by TriggerVM).
- [`func _set_dialog_pending(expr: String, ctx: Dictionary) -> void`](TriggerAPI/functions/_set_dialog_pending.md) — Set pending expression to execute when dialog closes (internal use by TriggerVM).
- [`func _on_dialog_closed() -> void`](TriggerAPI/functions/_on_dialog_closed.md) — Handle dialog closed signal (internal).
- [`func _bind_engineer_controller(engineer_ctrl: EngineerController) -> void`](TriggerAPI/functions/_bind_engineer_controller.md) — Bind to EngineerController to track bridge completions (internal, called by TriggerEngine).
- [`func _bind_artillery_controller(artillery_ctrl: ArtilleryController) -> void`](TriggerAPI/functions/_bind_artillery_controller.md) — Bind to ArtilleryController to track fire missions (internal, called by TriggerEngine).
- [`func _on_engineer_task_completed(_unit_id: String, task_type: String, _target_pos: Vector2) -> void`](TriggerAPI/functions/_on_engineer_task_completed.md) — Handle engineer task completion signal (internal).

## Public Attributes

- `SimWorld sim` — Whitelisted helper API for trigger scripts.
- `TriggerEngine engine`
- `drawing_controller`
- `MapController map_controller`
- `String _last_radio_command`
- `Control _mission_dialog`
- `_counter_controller`
- `bool _sleep_requested`
- `float _sleep_duration`
- `bool _sleep_use_realtime`
- `bool _dialog_blocking`
- `String _dialog_pending_expr`
- `Dictionary _dialog_pending_ctx`
- `int _bridges_built`
- `int _artillery_called`
- `Dictionary _current_context`

## Member Function Documentation

### time_s

```gdscript
func time_s() -> float
```

Return mission time in seconds.
[return] Mission time in seconds.

### is_paused

```gdscript
func is_paused() -> bool
```

Check if simulation is paused.
[return] True if simulation is paused.

### is_running

```gdscript
func is_running() -> bool
```

Check if simulation is running.
[return] True if simulation is running.

### time_scale

```gdscript
func time_scale() -> float
```

Get current time scale (1.0 = normal, 2.0 = 2x speed).
[return] Current time scale multiplier.

### sim_state

```gdscript
func sim_state() -> String
```

Get simulation state as string ("INIT", "RUNNING", "PAUSED", "COMPLETED").
[return] Current simulation state name.

### radio

```gdscript
func radio(msg: String, level: String = "info", unit_say: String = "") -> void
```

Send a radio/log message (levels: info|warn|error).
Optionally specify which unit is speaking for the transcript.
`msg` Radio message.
`level` Optional Log level (info|warn|error).
`unit` Optional unit callsign/ID of the speaker (for transcript display).

### complete_objective

```gdscript
func complete_objective(id: StringName) -> void
```

Set objective state to completed.
`id` Objective ID.

### fail_objective

```gdscript
func fail_objective(id: StringName) -> void
```

Set objective state to failed.
`id` Objective ID.

### set_objective

```gdscript
func set_objective(id: StringName, state: int) -> void
```

Set objective state
`id` Objective ID.
`state` ObjectiveState enum.

### objective_state

```gdscript
func objective_state(id: StringName) -> int
```

Get current objective state via summary payload.
`id` Objective ID.
[return] Current objective state as int.

### unit

```gdscript
func unit(id_or_callsign: String) -> Dictionary
```

Minimal snapshot of a unit by id or callsign.
`id_or_callsign` Unit ID or Unit Callsign.
[return] {id, callsign, pos_m: Vector2, aff: int} or {}.

### find_callsign_by_role

```gdscript
func find_callsign_by_role(role: String) -> String
```

Find callsign of first playable unit with the specified role.
Searches through playable units and returns the callsign of the first unit
whose UnitData.role matches the specified role string.
`role` Role string to search for (e.g., "RECON", "ARMOR", "AT", "ENG").
[return] Callsign string of first matching unit, or empty string if not found.

### last_radio_command

```gdscript
func last_radio_command() -> String
```

Get the last radio command heard this tick (cleared after tick).
Useful for trigger conditions to match custom voice commands.
[return] Last radio command text (lowercase, normalized).

### _set_last_radio_command

```gdscript
func _set_last_radio_command(cmd: String) -> void
```

Internal: Set the last radio command (called by TriggerEngine).
`cmd` Raw command text from Radio.

### get_global

```gdscript
func get_global(key: String, default: Variant = null) -> Variant
```

Get a global variable shared across all triggers.
Global variables persist across ticks and are visible to all triggers.
`key` Variable name.
`default` Default value if variable doesn't exist.
[return] Variable value or default.

### set_global

```gdscript
func set_global(key: String, value: Variant) -> void
```

Set a global variable shared across all triggers.
Global variables persist across ticks and are visible to all triggers.
`key` Variable name.
`value` Value to store.

### has_global

```gdscript
func has_global(key: String) -> bool
```

Check if a global variable exists.
`key` Variable name.
[return] True if variable exists.

### triggering_units_friend

```gdscript
func triggering_units_friend() -> Array
```

Get list of friendly unit IDs currently inside the trigger area.
Only works when called from within a trigger condition or action expression.
[return] Array of friendly unit IDs in trigger area, or empty array if not called from trigger.

### triggering_units_enemy

```gdscript
func triggering_units_enemy() -> Array
```

Get list of enemy unit IDs currently inside the trigger area.
Only works when called from within a trigger condition or action expression.
[return] Array of enemy unit IDs in trigger area, or empty array if not called from trigger.

### triggering_units_player

```gdscript
func triggering_units_player() -> Array
```

Get list of player-controlled unit IDs currently inside the trigger area.
Only works when called from within a trigger condition or action expression.
[return] Array of player unit IDs in trigger area, or empty array if not called from trigger.

### triggering_unit_friend

```gdscript
func triggering_unit_friend() -> String
```

Get the first friendly unit ID that triggered this area (convenience method).
Returns empty string if no friendly units in area.
[return] First friendly unit ID in trigger area, or empty string.

### triggering_unit_enemy

```gdscript
func triggering_unit_enemy() -> String
```

Get the first enemy unit ID that triggered this area (convenience method).
Returns empty string if no enemy units in area.
[return] First enemy unit ID in trigger area, or empty string.

### triggering_unit_player

```gdscript
func triggering_unit_player() -> String
```

Get the first player-controlled unit ID that triggered this area (convenience method).
Returns empty string if no player units in area.
[return] First player unit ID in trigger area, or empty string.

### is_unit_in_trigger_area

```gdscript
func is_unit_in_trigger_area(callsign: String) -> bool
```

Check if a specific unit is currently inside the trigger area.
Only works when called from within a trigger condition or action expression.
Checks across all affiliation categories (friend, enemy, player).
`callsign` Unit callsign to check.
[return] True if unit is in trigger area, false otherwise or if not in trigger context.

### tutorial_dialog

```gdscript
func tutorial_dialog(text: String, node_identifier: String = "", block: bool = true) -> void
```

Show a tutorial dialog with a line pointing to a UI element.
Designed for tutorial sequences to highlight specific tools, buttons, or UI elements.
Automatically pauses the simulation and points at the specified node.
By default, blocks execution until the dialog is dismissed (can be disabled).
`text` Dialog text to display (supports BBCode formatting)
`node_identifier` Node name, unique name (%), or path to point at
`block` If true (default), blocks execution until dialog is closed

### has_drawn

```gdscript
func has_drawn() -> bool
```

Check if the player has drawn anything on the map.
Returns true if any pen strokes have been made with the drawing tools.
  
  

**Usage in trigger condition:**
[return] True if player has made any drawings.

### get_drawing_count

```gdscript
func get_drawing_count() -> int
```

Get the number of drawing strokes the player has made.
Each continuous pen stroke counts as one stroke.
  
  

**Usage in trigger condition:**
[return] Number of strokes drawn.

### has_created_counter

```gdscript
func has_created_counter() -> bool
```

Check if the player has created any unit counters.
Returns true if at least one counter has been spawned.
  
  

**Usage in trigger condition:**
[return] True if player has created at least one counter.

### get_counter_count

```gdscript
func get_counter_count() -> int
```

Get the number of unit counters the player has created.
  
  

**Usage in trigger condition:**
[return] Number of counters created.

### is_unit_in_combat

```gdscript
func is_unit_in_combat(id_or_callsign: String) -> bool
```

Check if a unit is currently in combat (has spotted enemies).
Returns true if the unit has line-of-sight to any enemy units.
  
  

**Usage in trigger condition:**
`id_or_callsign` Unit ID or callsign to check.
[return] True if unit has spotted enemies (in combat).

### get_unit_position

```gdscript
func get_unit_position(id_or_callsign: String) -> Variant
```

Get the current position of a unit in terrain meters (Vector2).
`id_or_callsign` Unit ID or callsign.
[return] Vector2 position in terrain meters, or null if unit not found.

### get_unit_grid

```gdscript
func get_unit_grid(id_or_callsign: String, digits: int = 6) -> String
```

Get the current grid position of a unit (e.g., "630852").
`id_or_callsign` Unit ID or callsign.
`digits` Total number of digits in grid (default 6).
[return] Grid position string (e.g., "630852"), or empty string if unit not found.

### is_unit_destroyed

```gdscript
func is_unit_destroyed(id_or_callsign: String) -> bool
```

Check if a unit is destroyed (wiped out, state_strength == 0).
Returns true if the unit is dead or has zero strength.
`id_or_callsign` Unit ID or callsign to check.
[return] True if unit is destroyed/dead, false if alive or not found.

### get_unit_strength

```gdscript
func get_unit_strength(id_or_callsign: String) -> float
```

Get the current strength of a unit.
Strength is calculated as base strength × state_strength.
`id_or_callsign` Unit ID or callsign.
[return] Current strength value (0.0 if destroyed/not found).

### set_unit_fuel

```gdscript
func set_unit_fuel(id_or_callsign: String, fuel_pct: float) -> bool
```

Set the fuel level of a unit (for scripted events and tutorials).
Fuel is specified as a percentage (0-100).
`id_or_callsign` Unit ID or callsign.
`fuel_pct` Fuel percentage (0-100).
[return] True if fuel was successfully set, false if unit or FuelSystem not found.

### has_built_bridge

```gdscript
func has_built_bridge() -> bool
```

Check if any engineers have built a bridge.
Returns true if at least one bridge has been completed.
[return] True if at least one bridge has been built.

### get_bridges_built

```gdscript
func get_bridges_built() -> int
```

Get the number of bridges built by engineers.
[return] Number of bridges built.

### has_called_artillery

```gdscript
func has_called_artillery() -> bool
```

Check if any artillery fire missions have been called.
Returns true if at least one artillery mission has been requested.
[return] True if at least one artillery mission has been called.

### get_artillery_calls

```gdscript
func get_artillery_calls() -> int
```

Get the number of artillery fire missions called.
[return] Number of artillery missions called.

### vec2

```gdscript
func vec2(x: float, y: float) -> Vector2
```

Create a Vector2 from x and y coordinates.
Use this helper to construct Vector2 in trigger expressions.
`x` X coordinate
`y` Y coordinate
[return] Vector2 with given coordinates

### vec3

```gdscript
func vec3(x: float, y: float, z: float) -> Vector3
```

Create a Vector3 from x, y, and z coordinates.
`x` X coordinate
`y` Y coordinate
`z` Z coordinate
[return] Vector3 with given coordinates

### color

```gdscript
func color(r: float, g: float, b: float, a: float = 1.0) -> Color
```

Create a Color from RGB or RGBA values (0.0 to 1.0).
`r` Red component (0.0 to 1.0)
`g` Green component (0.0 to 1.0)
`b` Blue component (0.0 to 1.0)
`a` Alpha component (0.0 to 1.0), defaults to 1.0
[return] Color with given components

### rect2

```gdscript
func rect2(x: float, y: float, width: float, height: float) -> Rect2
```

Create a Rect2 from position and size.
`x` X position
`y` Y position
`width` Width
`height` Height
[return] Rect2 with given position and size

### sleep

```gdscript
func sleep(duration_s: float) -> void
```

Pause execution for a duration (mission time).
All statements after this call will be delayed by the specified duration.
Uses mission time, so pausing the game pauses the sleep timer.
`duration_s` Duration in seconds (mission time) to pause execution

### sleep_ui

```gdscript
func sleep_ui(duration_s: float) -> void
```

Pause execution for a duration (real-time).
All statements after this call will be delayed by the specified duration.
Uses real-time, so the sleep continues even when the game is paused.
Useful for UI sequences and tutorials.
`duration_s` Duration in seconds (real-time) to pause execution

### _is_sleep_requested

```gdscript
func _is_sleep_requested() -> bool
```

Check if sleep was requested (internal use by TriggerVM).
[return] True if sleep was called.

### _get_sleep_duration

```gdscript
func _get_sleep_duration() -> float
```

Get sleep duration (internal use by TriggerVM).
[return] Sleep duration in seconds.

### _is_sleep_realtime

```gdscript
func _is_sleep_realtime() -> bool
```

Check if sleep uses realtime (internal use by TriggerVM).
[return] True if sleep_ui was called, false if sleep was called.

### _reset_sleep

```gdscript
func _reset_sleep() -> void
```

Reset sleep state (internal use by TriggerVM).

### _is_dialog_blocking

```gdscript
func _is_dialog_blocking() -> bool
```

Check if dialog blocking is active (internal use by TriggerVM).
[return] True if waiting for dialog to close.

### _set_dialog_pending

```gdscript
func _set_dialog_pending(expr: String, ctx: Dictionary) -> void
```

Set pending expression to execute when dialog closes (internal use by TriggerVM).
`expr` Expression to execute.
`ctx` Context dictionary.

### _on_dialog_closed

```gdscript
func _on_dialog_closed() -> void
```

Handle dialog closed signal (internal).

### _bind_engineer_controller

```gdscript
func _bind_engineer_controller(engineer_ctrl: EngineerController) -> void
```

Bind to EngineerController to track bridge completions (internal, called by TriggerEngine).
`engineer_ctrl` EngineerController reference.

### _bind_artillery_controller

```gdscript
func _bind_artillery_controller(artillery_ctrl: ArtilleryController) -> void
```

Bind to ArtilleryController to track fire missions (internal, called by TriggerEngine).
`artillery_ctrl` ArtilleryController reference.

### _on_engineer_task_completed

```gdscript
func _on_engineer_task_completed(_unit_id: String, task_type: String, _target_pos: Vector2) -> void
```

Handle engineer task completion signal (internal).

## Member Data Documentation

### sim

```gdscript
var sim: SimWorld
```

Whitelisted helper API for trigger scripts.
Methods are available inside condition/on_activate/on_deactivate expressions.

### engine

```gdscript
var engine: TriggerEngine
```

### drawing_controller

```gdscript
var drawing_controller
```

### map_controller

```gdscript
var map_controller: MapController
```

### _last_radio_command

```gdscript
var _last_radio_command: String
```

### _mission_dialog

```gdscript
var _mission_dialog: Control
```

### _counter_controller

```gdscript
var _counter_controller
```

### _sleep_requested

```gdscript
var _sleep_requested: bool
```

### _sleep_duration

```gdscript
var _sleep_duration: float
```

### _sleep_use_realtime

```gdscript
var _sleep_use_realtime: bool
```

### _dialog_blocking

```gdscript
var _dialog_blocking: bool
```

### _dialog_pending_expr

```gdscript
var _dialog_pending_expr: String
```

### _dialog_pending_ctx

```gdscript
var _dialog_pending_ctx: Dictionary
```

### _bridges_built

```gdscript
var _bridges_built: int
```

### _artillery_called

```gdscript
var _artillery_called: int
```

### _current_context

```gdscript
var _current_context: Dictionary
```
