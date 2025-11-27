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
  
  

**Usage in trigger expressions:**

```
# Show dialog without pausing
show_dialog("Enemy reinforcements spotted!")

# Show dialog and pause game
show_dialog("Mission briefing: Secure the village.", true)

# Show dialog with a line pointing to a map position
show_dialog("Check this location!", false, vec2(500, 750))

# Show dialog pointing to a unit's position
var enemy = unit("BRAVO")
if enemy:
show_dialog("Watch out for enemies here!", true, enemy.position_m)

# Block execution until dialog is closed
show_dialog("First message", true, null, true)
show_dialog("This shows after first is closed", true, null, true)
```

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
- [`func radio(msg: String, level: String = "info") -> void`](TriggerAPI/functions/radio.md) — Send a radio/log message (levels: info|warn|error).
- [`func complete_objective(id: StringName) -> void`](TriggerAPI/functions/complete_objective.md) — Set objective state to completed.
- [`func fail_objective(id: StringName) -> void`](TriggerAPI/functions/fail_objective.md) — Set objective state to failed.
- [`func set_objective(id: StringName, state: int) -> void`](TriggerAPI/functions/set_objective.md) — Set objective state
`id` Objective ID.
- [`func objective_state(id: StringName) -> int`](TriggerAPI/functions/objective_state.md) — Get current objective state via summary payload.
- [`func unit(id_or_callsign: String) -> Dictionary`](TriggerAPI/functions/unit.md) — Minimal snapshot of a unit by id or callsign.
- [`func last_radio_command() -> String`](TriggerAPI/functions/last_radio_command.md) — Get the last radio command heard this tick (cleared after tick).
- [`func _set_last_radio_command(cmd: String) -> void`](TriggerAPI/functions/_set_last_radio_command.md) — Internal: Set the last radio command (called by TriggerEngine).
- [`func get_global(key: String, default: Variant = null) -> Variant`](TriggerAPI/functions/get_global.md) — Get a global variable shared across all triggers.
- [`func set_global(key: String, value: Variant) -> void`](TriggerAPI/functions/set_global.md) — Set a global variable shared across all triggers.
- [`func has_global(key: String) -> bool`](TriggerAPI/functions/has_global.md) — Check if a global variable exists.
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
func radio(msg: String, level: String = "info") -> void
```

Send a radio/log message (levels: info|warn|error).
`msg` Radio message.
`level` Optional Log level.

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

### last_radio_command

```gdscript
func last_radio_command() -> String
```

Get the last radio command heard this tick (cleared after tick).
Useful for trigger conditions to match custom voice commands.
  
  

**Usage in trigger condition_expr:**

```
last_radio_command().contains("fire mission")
last_radio_command() == "thunder actual"
```

  

**Note:** Command is automatically cleared after each tick, so triggers
only fire once per voice command.
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
  
  

**Usage in trigger expressions:**

```
# In trigger A:
set_global("mission_phase", 2)

# In trigger B (can read what A wrote):
if get_global("mission_phase", 0) >= 2:
radio("Phase 2 started")
```

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

### tutorial_dialog

```gdscript
func tutorial_dialog(text: String, node_identifier: String = "", block: bool = true) -> void
```

Show a tutorial dialog with a line pointing to a UI element.
Designed for tutorial sequences to highlight specific tools, buttons, or UI elements.
Automatically pauses the simulation and points at the specified node.
By default, blocks execution until the dialog is dismissed (can be disabled).
  
  

**Usage in trigger expressions:**

```
# Point to a node by unique name (% prefix) - blocks until dismissed
tutorial_dialog("This is the radio button. Press spacebar to transmit.", "%RadioButton")

# Point to a node by name (searches from root)
tutorial_dialog("Use this tool to draw on the map.", "DrawingTool")

# Point to a node by path
tutorial_dialog("These are your unit cards.", "HBoxContainer/UnitPanel")

# Tutorial sequence - automatically waits for each dialog to be dismissed
tutorial_dialog("Welcome to the mission!")
tutorial_dialog("This is the map viewer.", "%MapViewer")
tutorial_dialog("Click and drag to pan the map.", "%MapViewer")
tutorial_dialog("Press spacebar to use the radio.", "%RadioButton")

# Non-blocking tutorial dialog (old behavior with sleep_ui)
tutorial_dialog("Watch this!", "%SomeNode", false)
sleep_ui(3.0)
tutorial_dialog("Now this!", "%OtherNode", false)
```

  

**Note:** The dialog will automatically pause the simulation. Node lookup tries:
  
1. Unique name lookup (if starts with %)
  
2. Direct path from dialog node
  
3. Recursive search from root by name
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

```
# Trigger activates when player has drawn on the map
has_drawn()

# Combined with other conditions
has_drawn() and time_s() > 60
```

[return] True if player has made any drawings.

### get_drawing_count

```gdscript
func get_drawing_count() -> int
```

Get the number of drawing strokes the player has made.
Each continuous pen stroke counts as one stroke.
  
  

**Usage in trigger condition:**

```
# Trigger when player has drawn at least 3 strokes
get_drawing_count() >= 3

# Combined with location check
get_drawing_count() > 0 and count_in_area("friend", Vector2(500, 500), Vector2(100, 100)) > 0
```

[return] Number of strokes drawn.

### has_created_counter

```gdscript
func has_created_counter() -> bool
```

Check if the player has created any unit counters.
Returns true if at least one counter has been spawned.
  
  

**Usage in trigger condition:**

```
# Trigger activates when player has created a counter
has_created_counter()

# Combined with other conditions
has_created_counter() and time_s() > 30
```

[return] True if player has created at least one counter.

### get_counter_count

```gdscript
func get_counter_count() -> int
```

Get the number of unit counters the player has created.
  
  

**Usage in trigger condition:**

```
# Trigger when player has created at least 3 counters
get_counter_count() >= 3

# Combined with other conditions
get_counter_count() > 0 and time_s() > 60
```

[return] Number of counters created.

### is_unit_in_combat

```gdscript
func is_unit_in_combat(id_or_callsign: String) -> bool
```

Check if a unit is currently in combat (has spotted enemies).
Returns true if the unit has line-of-sight to any enemy units.
  
  

**Usage in trigger condition:**

```
# Trigger when ALPHA unit is in combat
is_unit_in_combat("ALPHA")

# Trigger when any player unit is in combat
var u = unit("ALPHA")
if u:
is_unit_in_combat(u.id)

# Tutorial: explain combat when ambushed
is_unit_in_combat("ALPHA") and not has_global("combat_tutorial_shown")
```

`id_or_callsign` Unit ID or callsign to check.
[return] True if unit has spotted enemies (in combat).

### get_unit_position

```gdscript
func get_unit_position(id_or_callsign: String) -> Variant
```

Get the current position of a unit in terrain meters (Vector2).
  
  

**Usage in trigger expressions:**

```
# Get unit position
var pos = get_unit_position("ALPHA")
radio("ALPHA is at position " + str(pos))

# Check if unit reached a location
var target = vec2(1000, 500)
var pos = get_unit_position("ALPHA")
if pos and pos.distance_to(target) < 50:
radio("ALPHA reached the objective!")

# Point dialog at unit's current position
var pos = get_unit_position("BRAVO")
if pos:
show_dialog("Enemy spotted here!", false, pos)
```

`id_or_callsign` Unit ID or callsign.
[return] Vector2 position in terrain meters, or null if unit not found.

### get_unit_grid

```gdscript
func get_unit_grid(id_or_callsign: String, digits: int = 6) -> String
```

Get the current grid position of a unit (e.g., "630852").
  
  

**Usage in trigger expressions:**

```
# Get unit grid position
var grid = get_unit_grid("ALPHA")
radio("ALPHA is at grid " + grid)

# Tutorial: explain grid coordinates
var grid = get_unit_grid("ALPHA")
tutorial_dialog("You are at grid " + grid + ". Use this for radio reports.")

# Check if unit is in specific grid area
var grid = get_unit_grid("BRAVO")
if grid.begins_with("63"):
radio("BRAVO is in the northern sector")
```

`id_or_callsign` Unit ID or callsign.
`digits` Total number of digits in grid (default 6).
[return] Grid position string (e.g., "630852"), or empty string if unit not found.

### is_unit_destroyed

```gdscript
func is_unit_destroyed(id_or_callsign: String) -> bool
```

Check if a unit is destroyed (wiped out, state_strength == 0).
Returns true if the unit is dead or has zero strength.
  
  

**Usage in trigger expressions:**

```
# Trigger when ALPHA is destroyed
is_unit_destroyed("ALPHA")

# Check for unit destruction and complete objective
if is_unit_destroyed("ENEMY_1"):
complete_objective("destroy_enemy")
radio("Enemy unit eliminated!")

# Tutorial: explain unit loss
if is_unit_destroyed("ALPHA") and not has_global("unit_loss_tutorial_shown"):
set_global("unit_loss_tutorial_shown", true)
show_dialog("Your unit has been destroyed!", true)
```

`id_or_callsign` Unit ID or callsign to check.
[return] True if unit is destroyed/dead, false if alive or not found.

### get_unit_strength

```gdscript
func get_unit_strength(id_or_callsign: String) -> float
```

Get the current strength of a unit.
Strength is calculated as base strength × state_strength.
  
  

**Usage in trigger expressions:**

```
# Check if unit is below 50% strength
if get_unit_strength("ALPHA") < 50:
radio("ALPHA is heavily damaged!")

# Trigger when unit strength is critical
get_unit_strength("ALPHA") > 0 and get_unit_strength("ALPHA") < 20

# Compare strengths
var alpha_str = get_unit_strength("ALPHA")
var bravo_str = get_unit_strength("BRAVO")
if alpha_str > bravo_str * 2:
radio("ALPHA is significantly stronger than BRAVO")

# Tutorial: explain unit strength
if get_unit_strength("ALPHA") < 30 and not has_global("strength_warning_shown"):
set_global("strength_warning_shown", true)
tutorial_dialog("Your unit strength is low! Consider withdrawing.")
```

`id_or_callsign` Unit ID or callsign.
[return] Current strength value (0.0 if destroyed/not found).

### has_built_bridge

```gdscript
func has_built_bridge() -> bool
```

Check if any engineers have built a bridge.
Returns true if at least one bridge has been completed.
  
  

**Usage in trigger expressions:**

```
# Trigger when first bridge is built
has_built_bridge()

# Tutorial: explain bridge building
if has_built_bridge() and not has_global("bridge_tutorial_shown"):
set_global("bridge_tutorial_shown", true)
radio("Well done! The bridge is complete.")
show_dialog("Engineers can build bridges across water obstacles.")

# Complete objective when bridge built
if has_built_bridge():
complete_objective("build_crossing")
```

[return] True if at least one bridge has been built.

### get_bridges_built

```gdscript
func get_bridges_built() -> int
```

Get the number of bridges built by engineers.
  
  

**Usage in trigger expressions:**

```
# Trigger when 2 bridges are built
get_bridges_built() >= 2

# Radio report on progress
var count = get_bridges_built()
radio("Engineers have completed " + str(count) + " bridge(s)")

# Tutorial: reinforce successful bridge building
if get_bridges_built() >= 3:
show_dialog("Excellent work! Your engineers are very efficient.")
```

[return] Number of bridges built.

### has_called_artillery

```gdscript
func has_called_artillery() -> bool
```

Check if any artillery fire missions have been called.
Returns true if at least one artillery mission has been requested.
  
  

**Usage in trigger expressions:**

```
# Trigger when first artillery is called
has_called_artillery()

# Tutorial: explain artillery usage
if has_called_artillery() and not has_global("artillery_tutorial_shown"):
set_global("artillery_tutorial_shown", true)
radio("Shot! Rounds on the way.")
show_dialog("Artillery takes time to impact. Listen for 'Splash' warning.")

# Complete objective when artillery called
if has_called_artillery():
complete_objective("call_fire_support")
```

[return] True if at least one artillery mission has been called.

### get_artillery_calls

```gdscript
func get_artillery_calls() -> int
```

Get the number of artillery fire missions called.
  
  

**Usage in trigger expressions:**

```
# Trigger when 3 fire missions called
get_artillery_calls() >= 3

# Radio report on fire support usage
var count = get_artillery_calls()
radio("We've called " + str(count) + " fire mission(s) so far")

# Tutorial: warn about ammo conservation
if get_artillery_calls() > 5:
show_dialog("Watch your artillery ammunition - you only have limited rounds!")
```

[return] Number of artillery missions called.

### vec2

```gdscript
func vec2(x: float, y: float) -> Vector2
```

Create a Vector2 from x and y coordinates.
Use this helper to construct Vector2 in trigger expressions.
  
  

**Usage in trigger expressions:**

```
# Show dialog with line to position
show_dialog("Check here!", false, vec2(500, 750))

# Store position in global variable
set_global("checkpoint", vec2(1000, 500))
```

`x` X coordinate
`y` Y coordinate
[return] Vector2 with given coordinates

### vec3

```gdscript
func vec3(x: float, y: float, z: float) -> Vector3
```

Create a Vector3 from x, y, and z coordinates.
  
  

**Usage in trigger expressions:**

```
# Create 3D position
set_global("spawn_point", vec3(500, 0, 750))
```

`x` X coordinate
`y` Y coordinate
`z` Z coordinate
[return] Vector3 with given coordinates

### color

```gdscript
func color(r: float, g: float, b: float, a: float = 1.0) -> Color
```

Create a Color from RGB or RGBA values (0.0 to 1.0).
  
  

**Usage in trigger expressions:**

```
# Create red color
set_global("marker_color", color(1.0, 0.0, 0.0))

# Create semi-transparent blue
set_global("marker_color", color(0.0, 0.0, 1.0, 0.5))
```

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
  
  

**Usage in trigger expressions:**

```
# Create rectangle area
set_global("patrol_area", rect2(500, 750, 200, 100))
```

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
  
  

**Usage in trigger expressions:**

```
# Show sequential messages
show_dialog("First message")
sleep(5.0)
show_dialog("Second message after 5 seconds")
sleep(3.0)
show_dialog("Third message after 8 seconds total")

# Countdown sequence
radio("Starting countdown...")
sleep(3.0)
radio("3...")
sleep(3.0)
radio("2...")
sleep(3.0)
radio("1...")
sleep(3.0)
radio("Go!")
set_objective("start", 1)

# Dialog with position then delayed attack order
show_dialog("Watch this position", false, vec2(500, 500))
sleep(5.0)
show_dialog("Attack here!", false, vec2(1000, 1000))
sleep(2.0)
radio("All units, engage!")
```

`duration_s` Duration in seconds (mission time) to pause execution

### sleep_ui

```gdscript
func sleep_ui(duration_s: float) -> void
```

Pause execution for a duration (real-time).
All statements after this call will be delayed by the specified duration.
Uses real-time, so the sleep continues even when the game is paused.
Useful for UI sequences and tutorials.
  
  

**Usage in trigger expressions:**

```
# Tutorial sequence that continues even if player pauses
show_dialog("Welcome to the tutorial", true)
sleep_ui(2.0)
show_dialog("Step 1: Use radio checks", true)
sleep_ui(3.0)
show_dialog("Step 2: Place markers", true)

# Timed UI feedback
radio("Command acknowledged")
sleep_ui(1.5)
radio("Executing order...")
sleep_ui(2.0)
radio("Order complete")
```

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
