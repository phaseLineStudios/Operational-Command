# ForestTerrain Class Reference

*File:* `scripts/terrain/environments/ForestTerrain.gd`
*Class name:* `ForestTerrain`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name ForestTerrain
extends Node
```

## Public Member Functions

- [`func _ready() -> void`](ForestTerrain/functions/_ready.md)
- [`func scenario_changed(new_scenario: ScenarioData) -> void`](ForestTerrain/functions/scenario_changed.md)
- [`func check_rain() -> void`](ForestTerrain/functions/check_rain.md)

## Public Attributes

- `SceneEnvironment scene_env`
- `Node3D terrain`
- `MeshInstance3D terrain_mesh`
- `ScenarioData _scenario`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### scenario_changed

```gdscript
func scenario_changed(new_scenario: ScenarioData) -> void
```

### check_rain

```gdscript
func check_rain() -> void
```

## Member Data Documentation

### scene_env

```gdscript
var scene_env: SceneEnvironment
```

### terrain

```gdscript
var terrain: Node3D
```

### terrain_mesh

```gdscript
var terrain_mesh: MeshInstance3D
```

### _scenario

```gdscript
var _scenario: ScenarioData
```
