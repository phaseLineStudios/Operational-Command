# CombatTest Class Reference

*File:* `scripts/test/CombatTest.gd`
*Class name:* `CombatTest`
*Inherits:* `Node2D`

## Synopsis

```gdscript
class_name CombatTest
extends Node2D
```

## Brief

Minimal combat/movement + combat debug harness.

## Detailed Description

IDs of the two placed units in ScenarioData.content.units

## Public Member Functions

- [`func _ready() -> void`](CombatTest/functions/_ready.md)
- [`func _process(dt: float) -> void`](CombatTest/functions/_process.md)
- [`func _input(e: InputEvent) -> void`](CombatTest/functions/_input.md)
- [`func _move_su_to(su: ScenarioUnit, dest_m: Vector2) -> void`](CombatTest/functions/_move_su_to.md)
- [`func _load_scenario_json(path: String) -> Dictionary`](CombatTest/functions/_load_scenario_json.md)
- [`func _find_su(list: Array[ScenarioUnit], key: String) -> ScenarioUnit`](CombatTest/functions/_find_su.md)

## Public Attributes

- `String scenario_data_json` — Scenario JSON file
- `ScenarioData _scenario`
- `ScenarioUnit _su_a`
- `ScenarioUnit _su_b`
- `FuelSystem fuel` — Using FuelSystem
- `TerrainRender renderer`
- `Camera2D camera`
- `Control input_overlay`
- `CombatController combat`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _process

```gdscript
func _process(dt: float) -> void
```

### _input

```gdscript
func _input(e: InputEvent) -> void
```

### _move_su_to

```gdscript
func _move_su_to(su: ScenarioUnit, dest_m: Vector2) -> void
```

### _load_scenario_json

```gdscript
func _load_scenario_json(path: String) -> Dictionary
```

### _find_su

```gdscript
func _find_su(list: Array[ScenarioUnit], key: String) -> ScenarioUnit
```

## Member Data Documentation

### scenario_data_json

```gdscript
var scenario_data_json: String
```

Decorators: `@export_file("*.json ; Scenario")`

Scenario JSON file

### _scenario

```gdscript
var _scenario: ScenarioData
```

### _su_a

```gdscript
var _su_a: ScenarioUnit
```

### _su_b

```gdscript
var _su_b: ScenarioUnit
```

### fuel

```gdscript
var fuel: FuelSystem
```

Decorators: `@onready`

Using FuelSystem

### renderer

```gdscript
var renderer: TerrainRender
```

### camera

```gdscript
var camera: Camera2D
```

### input_overlay

```gdscript
var input_overlay: Control
```

### combat

```gdscript
var combat: CombatController
```
