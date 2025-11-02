# UnitMgmt Class Reference

*File:* `scripts/ui/UnitMgmt.gd`
*Inherits:* `Control`

## Synopsis

```gdscript
extends Control
```

## Public Member Functions

- [`func _ready() -> void`](UnitMgmt/functions/_ready.md) — Scene is ready: wire signals and populate UI from Game.
- [`func _refresh_from_game() -> void`](UnitMgmt/functions/_refresh_from_game.md) — Pull units from Game and refresh list and panel.
- [`func _collect_units_from_game() -> Array[UnitData]`](UnitMgmt/functions/_collect_units_from_game.md) — Return a flat array of UnitData from the current scenario or recruits.
- [`func _get_pool() -> int`](UnitMgmt/functions/_get_pool.md) — Read the replacement pool from Game (placeholder persistence).
- [`func _set_pool(v: int) -> void`](UnitMgmt/functions/_set_pool.md) — Write the replacement pool to Game (placeholder persistence).
- [`func _on_preview_changed(_unit_id: String, _amt: int) -> void`](UnitMgmt/functions/_on_preview_changed.md) — Live preview hook from panel (visual-only here).
- [`func _on_committed(plan: Dictionary) -> void`](UnitMgmt/functions/_on_committed.md) — Apply a committed plan:
clamp to capacity and pool, then signal status changes.
- [`func _find_unit(uid: String) -> UnitData`](UnitMgmt/functions/_find_unit.md) — Find a unit by id in the cached list.
- [`func _status_string(u: UnitData) -> String`](UnitMgmt/functions/_status_string.md) — Derive a status string for external consumers.
- [`func _can_reinforce(u: UnitData) -> bool`](UnitMgmt/functions/_can_reinforce.md) — Test if a unit can be reinforced (this screen cannot reinforce wiped-out units).

## Public Attributes

- `Array[UnitData] _units`
- `Dictionary _uid_to_index`
- `VBoxContainer _list_box`
- `ReinforcementPanel _panel`
- `Button _btn_refresh`

## Signals

- `signal unit_strength_changed(unit_id: String, current: int, status: String)` — Unit Management screen controller.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Scene is ready: wire signals and populate UI from Game.

### _refresh_from_game

```gdscript
func _refresh_from_game() -> void
```

Pull units from Game and refresh list and panel.

### _collect_units_from_game

```gdscript
func _collect_units_from_game() -> Array[UnitData]
```

Return a flat array of UnitData from the current scenario or recruits.

### _get_pool

```gdscript
func _get_pool() -> int
```

Read the replacement pool from Game (placeholder persistence).

### _set_pool

```gdscript
func _set_pool(v: int) -> void
```

Write the replacement pool to Game (placeholder persistence).

### _on_preview_changed

```gdscript
func _on_preview_changed(_unit_id: String, _amt: int) -> void
```

Live preview hook from panel (visual-only here).

### _on_committed

```gdscript
func _on_committed(plan: Dictionary) -> void
```

Apply a committed plan:
clamp to capacity and pool, then signal status changes.

### _find_unit

```gdscript
func _find_unit(uid: String) -> UnitData
```

Find a unit by id in the cached list.

### _status_string

```gdscript
func _status_string(u: UnitData) -> String
```

Derive a status string for external consumers.

### _can_reinforce

```gdscript
func _can_reinforce(u: UnitData) -> bool
```

Test if a unit can be reinforced (this screen cannot reinforce wiped-out units).

## Member Data Documentation

### _units

```gdscript
var _units: Array[UnitData]
```

### _uid_to_index

```gdscript
var _uid_to_index: Dictionary
```

### _list_box

```gdscript
var _list_box: VBoxContainer
```

### _panel

```gdscript
var _panel: ReinforcementPanel
```

### _btn_refresh

```gdscript
var _btn_refresh: Button
```

## Signal Documentation

### unit_strength_changed

```gdscript
signal unit_strength_changed(unit_id: String, current: int, status: String)
```

Unit Management screen controller. Integrates ReinforcementPanel with unit list.
This scene expects a Game singleton with current_scenario and an integer
Game.campaign_replacement_pool for the shared personnel pool.
When the player commits a plan, this applies the allocations to UnitData
and emits unit_strength_changed for each modified unit.to UnitData.
