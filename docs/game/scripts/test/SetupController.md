# SetupController Class Reference

*File:* `scripts/test/PathTest.gd`
*Class name:* `SetupController`
*Inherits:* `Node2D`

## Synopsis

```gdscript
class_name SetupController
extends Node2D
```

## Brief

Wires TerrainRender, PathGrid, and a MovementAgent, then handles click-to-move.

## Public Member Functions

- [`func _ready() -> void`](SetupController/functions/_ready.md)
- [`func _input(e: InputEvent) -> void`](SetupController/functions/_input.md)

## Public Attributes

- `String terrain_path` — Terrain to load
- `TerrainData terrain`
- `TerrainRender renderer`
- `Camera2D camera`
- `MovementAgent unit`
- `Control input_overlay`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _input

```gdscript
func _input(e: InputEvent) -> void
```

## Member Data Documentation

### terrain_path

```gdscript
var terrain_path: String
```

Decorators: `@export_file("*.json")`

Terrain to load

### terrain

```gdscript
var terrain: TerrainData
```

### renderer

```gdscript
var renderer: TerrainRender
```

### camera

```gdscript
var camera: Camera2D
```

### unit

```gdscript
var unit: MovementAgent
```

### input_overlay

```gdscript
var input_overlay: Control
```
