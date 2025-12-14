# ReinforcementTest Class Reference

*File:* `scripts/test/ReinforcementTest.gd`
*Class name:* `ReinforcementTest`
*Inherits:* `Node2D`

## Synopsis

```gdscript
class_name ReinforcementTest
extends Node2D
```

## Public Member Functions

- [`func _ready() -> void`](ReinforcementTest/functions/_ready.md)
- [`func _on_committed(plan: Dictionary) -> void`](ReinforcementTest/functions/_on_committed.md) — Apply plan and keep Game + panel pools synchronized
- [`func _capture_baseline() -> void`](ReinforcementTest/functions/_capture_baseline.md)
- [`func _reset_to_baseline() -> void`](ReinforcementTest/functions/_reset_to_baseline.md) — Restore baseline strengths and pool (test-only behavior for the Reset button)
- [`func _make_unit_prefab() -> PackedScene`](ReinforcementTest/functions/_make_unit_prefab.md) — Make a tiny runtime PackedScene whose instance accepts a strength factor
- [`func apply_strength_factor(f: float) -> void`](ReinforcementTest/functions/apply_strength_factor.md)
- [`func _make_mock_scenario() -> Node`](ReinforcementTest/functions/_make_mock_scenario.md) — Build a mock scenario compatible with SimWorld.spawn_scenario_units()
- [`func _make_mock_scenario_unit(u: UnitData) -> Object`](ReinforcementTest/functions/_make_mock_scenario_unit.md) — Make a mock "ScenarioUnit" object (extends Object) with .unit and .packed_scene
- [`func _test_spawn() -> void`](ReinforcementTest/functions/_test_spawn.md) — Exercise SimWorld.spawn_scenario_units(): wiped-out filtered, factor forwarded
- [`func _test_casualties() -> void`](ReinforcementTest/functions/_test_casualties.md) — Prove that apply_casualties_to_units mutates state_strength in place
- [`func _make_demo_units() -> Array[UnitData]`](ReinforcementTest/functions/_make_demo_units.md) — Demo units (with per-unit threshold to validate badge/status)
- [`func _find(uid: String) -> UnitData`](ReinforcementTest/functions/_find.md) — Lookup by id

## Public Attributes

- `Array[UnitData] _units`
- `ReinforcementPanel _panel`
- `int _pool`
- `Dictionary[String, float] _unit_strength` — Temporary: tracks current strength per unit for testing
- `Dictionary _baseline_strengths`
- `int _baseline_pool`
- `float strength_factor`
- `int base_count`
- `int count`
- `PackedScene ps`

## Public Constants

- `const PANEL_SCENE: PackedScene` — Test harness that:

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _on_committed

```gdscript
func _on_committed(plan: Dictionary) -> void
```

Apply plan and keep Game + panel pools synchronized

### _capture_baseline

```gdscript
func _capture_baseline() -> void
```

### _reset_to_baseline

```gdscript
func _reset_to_baseline() -> void
```

Restore baseline strengths and pool (test-only behavior for the Reset button)

### _make_unit_prefab

```gdscript
func _make_unit_prefab() -> PackedScene
```

Make a tiny runtime PackedScene whose instance accepts a strength factor

### apply_strength_factor

```gdscript
func apply_strength_factor(f: float) -> void
```

### _make_mock_scenario

```gdscript
func _make_mock_scenario() -> Node
```

Build a mock scenario compatible with SimWorld.spawn_scenario_units()

### _make_mock_scenario_unit

```gdscript
func _make_mock_scenario_unit(u: UnitData) -> Object
```

Make a mock "ScenarioUnit" object (extends Object) with .unit and .packed_scene

### _test_spawn

```gdscript
func _test_spawn() -> void
```

Exercise SimWorld.spawn_scenario_units(): wiped-out filtered, factor forwarded

### _test_casualties

```gdscript
func _test_casualties() -> void
```

Prove that apply_casualties_to_units mutates state_strength in place

### _make_demo_units

```gdscript
func _make_demo_units() -> Array[UnitData]
```

Demo units (with per-unit threshold to validate badge/status)

### _find

```gdscript
func _find(uid: String) -> UnitData
```

Lookup by id

## Member Data Documentation

### _units

```gdscript
var _units: Array[UnitData]
```

### _panel

```gdscript
var _panel: ReinforcementPanel
```

### _pool

```gdscript
var _pool: int
```

### _unit_strength

```gdscript
var _unit_strength: Dictionary[String, float]
```

Temporary: tracks current strength per unit for testing

### _baseline_strengths

```gdscript
var _baseline_strengths: Dictionary
```

### _baseline_pool

```gdscript
var _baseline_pool: int
```

### strength_factor

```gdscript
var strength_factor: float
```

### base_count

```gdscript
var base_count: int
```

### count

```gdscript
var count: int
```

### ps

```gdscript
var ps: PackedScene
```

## Constant Documentation

### PANEL_SCENE

```gdscript
const PANEL_SCENE: PackedScene
```

Test harness that:
- Starts the pool at 10 (and syncs with Game if present)
- Wires Reset to restore a baseline
- Optionally auto-applies a sample plan
- Tests SimWorld spawning (filters wiped-out, applies strength factor)
- Tests casualty application at debrief time (via MissionResolution helper)
