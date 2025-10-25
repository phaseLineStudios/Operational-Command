# MovementAdapter Class Reference

*File:* `scripts/sim/adapters/MovementAdapter.gd`
*Class name:* `MovementAdapter`
*Inherits:* `Node`
> **Experimental**

## Synopsis

```gdscript
class_name MovementAdapter
extends Node
```

## Brief

Movement adapter for pathfinding-based unit orders.

## Detailed Description

@brief Plans and ticks movement using per-unit profiles (FOOT/WHEELED/
TRACKED/RIVERINE), groups ticks by profile for performance, and resolves
map label names into terrain positions for destination orders.

Map lowercase mobility tags/strings to movement profiles.

Enable resolving String destinations using TerrainData.labels[].text.

## Public Member Functions

- [`func _ready() -> void`](MovementAdapter/functions/_ready.md) — Initialize grid hooks and build the label index.
- [`func _refresh_label_index() -> void`](MovementAdapter/functions/_refresh_label_index.md) — Rebuilds the label lookup from TerrainData.labels.
- [`func _norm_label(s: String) -> String`](MovementAdapter/functions/_norm_label.md) — Normalizes label text for tolerant matching.
- [`func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant`](MovementAdapter/functions/_resolve_label_to_pos.md) — Resolves a label phrase to a terrain position in meters.
- [`func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool`](MovementAdapter/functions/plan_and_start_to_label.md) — Plans and starts movement to a map label.
- [`func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool`](MovementAdapter/functions/plan_and_start_any.md) — Plans and starts movement to either a Vector2 destination or a label.
- [`func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void`](MovementAdapter/functions/_prebuild_needed_profiles.md) — Ensures PathGrid profiles needed by `units` are available.
- [`func tick_units(units: Array[ScenarioUnit], dt: float) -> void`](MovementAdapter/functions/tick_units.md) — Ticks unit movement grouped by profile (reduces grid switching).
- [`func cancel_move(su: ScenarioUnit) -> void`](MovementAdapter/functions/cancel_move.md) — Pauses current movement for a unit.
- [`func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool`](MovementAdapter/functions/plan_and_start.md) — Plans and immediately starts movement to `dest_m`.
- [`func _on_grid_ready(profile: int) -> void`](MovementAdapter/functions/_on_grid_ready.md) — Starts any deferred moves whose profile just finished building.

## Public Attributes

- `TerrainRender renderer` — Terrain renderer providing the PathGrid and TerrainData.
- `int default_profile` — Default profile used when a unit has no explicit movement profile.
- `PathGrid _grid`
- `Dictionary _labels`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

Initialize grid hooks and build the label index.

### _refresh_label_index

```gdscript
func _refresh_label_index() -> void
```

Rebuilds the label lookup from TerrainData.labels.
Stores: normalized_text -> Array[Vector2] (terrain meters).

### _norm_label

```gdscript
func _norm_label(s: String) -> String
```

Normalizes label text for tolerant matching.
Removes punctuation, collapses spaces, and lowercases.
`s` Original label text.
[return] Normalized key.

### _resolve_label_to_pos

```gdscript
func _resolve_label_to_pos(label_text: String, origin_m: Vector2 = Vector2.INF) -> Variant
```

Resolves a label phrase to a terrain position in meters.
When multiple labels share the same text, picks the closest to origin.
`label_text` Label string to look up.
`origin_m` Optional origin (unit position) for tie-breaking.
[return] Vector2 position if found, otherwise null.

### plan_and_start_to_label

```gdscript
func plan_and_start_to_label(su: ScenarioUnit, label_text: String) -> bool
```

Plans and starts movement to a map label.
`su` ScenarioUnit to move.
`label_text` Label name to resolve.
[return] True if the order was accepted (or deferred), else false.

### plan_and_start_any

```gdscript
func plan_and_start_any(su: ScenarioUnit, dest: Variant) -> bool
```

Plans and starts movement to either a Vector2 destination or a label.
Also accepts {x,y} or {pos: Vector2} dictionaries.
`su` ScenarioUnit to move.
`dest` Vector2 | String | Dictionary destination.
[return] True if the order was accepted (or deferred), else false.

### _prebuild_needed_profiles

```gdscript
func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void
```

Ensures PathGrid profiles needed by `units` are available.
Triggers async builds for any missing profiles.

### tick_units

```gdscript
func tick_units(units: Array[ScenarioUnit], dt: float) -> void
```

Ticks unit movement grouped by profile (reduces grid switching).
Skips groups whose profile grid is still building this frame.
`units` Units to tick.
`dt` Delta time in seconds.

### cancel_move

```gdscript
func cancel_move(su: ScenarioUnit) -> void
```

Pauses current movement for a unit.
`su` ScenarioUnit to pause.

### plan_and_start

```gdscript
func plan_and_start(su: ScenarioUnit, dest_m: Vector2) -> bool
```

Plans and immediately starts movement to `dest_m`.
Defers start if the profile grid is still building.
`su` ScenarioUnit to move.
`dest_m` Destination in terrain meters.
[return] True if planned (or deferred), false on error or plan failure.

### _on_grid_ready

```gdscript
func _on_grid_ready(profile: int) -> void
```

Starts any deferred moves whose profile just finished building.
`profile` Movement profile that became available.

## Member Data Documentation

### renderer

```gdscript
var renderer: TerrainRender
```

Decorators: `@export`

Terrain renderer providing the PathGrid and TerrainData.

### default_profile

```gdscript
var default_profile: int
```

Decorators: `@export`

Default profile used when a unit has no explicit movement profile.

### _grid

```gdscript
var _grid: PathGrid
```

### _labels

```gdscript
var _labels: Dictionary
```
