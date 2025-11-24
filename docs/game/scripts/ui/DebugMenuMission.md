# DebugMenuMission Class Reference

*File:* `scripts/ui/DebugMenuMission.gd`
*Class name:* `DebugMenuMission`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name DebugMenuMission
extends RefCounted
```

## Public Member Functions

- [`func _init(status_label: Label, content_grid: GridContainer) -> void`](DebugMenuMission/functions/_init.md)
- [`func refresh(parent: Node) -> void`](DebugMenuMission/functions/refresh.md) — Refresh the mission debug UI with current mission data
- [`func _add_separator() -> void`](DebugMenuMission/functions/_add_separator.md) — Add a separator row
- [`func _find_sim_world(start_node: Node) -> Node`](DebugMenuMission/functions/_find_sim_world.md) — Find SimWorld node in the scene tree
- [`func _get_objective_state(obj_id: String) -> int`](DebugMenuMission/functions/_get_objective_state.md) — Get current objective state from Game.resolution
- [`func _set_objective_state(obj_id: String, state_int: int) -> void`](DebugMenuMission/functions/_set_objective_state.md) — Set objective state through Game

## Public Attributes

- `GridContainer mission_content` — Mission debug functionality for debug menu.
- `Label mission_status`

## Member Function Documentation

### _init

```gdscript
func _init(status_label: Label, content_grid: GridContainer) -> void
```

### refresh

```gdscript
func refresh(parent: Node) -> void
```

Refresh the mission debug UI with current mission data

### _add_separator

```gdscript
func _add_separator() -> void
```

Add a separator row

### _find_sim_world

```gdscript
func _find_sim_world(start_node: Node) -> Node
```

Find SimWorld node in the scene tree

### _get_objective_state

```gdscript
func _get_objective_state(obj_id: String) -> int
```

Get current objective state from Game.resolution

### _set_objective_state

```gdscript
func _set_objective_state(obj_id: String, state_int: int) -> void
```

Set objective state through Game

## Member Data Documentation

### mission_content

```gdscript
var mission_content: GridContainer
```

Mission debug functionality for debug menu.

Handles the UI and logic for debugging the active mission in the HQ table scene.
Only shows when a mission is active in the SimWorld.

### mission_status

```gdscript
var mission_status: Label
```
