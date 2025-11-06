# DrawingController Class Reference

*File:* `scripts/core/DrawingController.gd`
*Class name:* `DrawingController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name DrawingController
extends Node
```

## Public Member Functions

- [`func _init_drawing_mesh() -> void`](DrawingController/functions/_init_drawing_mesh.md)
- [`func _process(_delta: float) -> void`](DrawingController/functions/_process.md)
- [`func _update_current_tool() -> void`](DrawingController/functions/_update_current_tool.md)
- [`func _input(event: InputEvent) -> void`](DrawingController/functions/_input.md)
- [`func _start_drawing() -> void`](DrawingController/functions/_start_drawing.md)
- [`func _end_drawing() -> void`](DrawingController/functions/_end_drawing.md)
- [`func _erase_at_point(erase_point: Vector3) -> void`](DrawingController/functions/_erase_at_point.md) — Erase strokes at a single point
- [`func _split_into_segments(surviving_points: Array[Vector3], original_points: Array) -> Array`](DrawingController/functions/_split_into_segments.md) — Split points into continuous segments by detecting gaps in the original sequence
- [`func _update_drawing_mesh() -> void`](DrawingController/functions/_update_drawing_mesh.md)
- [`func _get_tool_color(tool: Tool) -> Color`](DrawingController/functions/_get_tool_color.md)
- [`func _project_mouse_to_map(mouse_pos: Vector2) -> Variant`](DrawingController/functions/_project_mouse_to_map.md)
- [`func set_tool(tool: Tool) -> void`](DrawingController/functions/set_tool.md) — Set the current drawing tool
- [`func get_tool() -> Tool`](DrawingController/functions/get_tool.md) — Get the current drawing tool
- [`func has_drawing() -> bool`](DrawingController/functions/has_drawing.md) — Check if any drawing has been made
- [`func clear_all() -> void`](DrawingController/functions/clear_all.md) — Clear all drawings
- [`func get_stroke_count() -> int`](DrawingController/functions/get_stroke_count.md) — Get total number of strokes drawn
- [`func load_scenario_drawings(scenario: ScenarioData, terrain_renderer: TerrainRender) -> void`](DrawingController/functions/load_scenario_drawings.md) — Load scenario drawings and render them.
- [`func _convert_scenario_stroke(drawing: ScenarioDrawingStroke) -> Dictionary`](DrawingController/functions/_convert_scenario_stroke.md) — Convert a ScenarioDrawingStroke to internal stroke format.
- [`func _terrain_to_world(pos_m: Vector2) -> Variant`](DrawingController/functions/_terrain_to_world.md) — Convert terrain 2D position to 3D world position on the map.
- [`func _color_to_tool(color: Color) -> Tool`](DrawingController/functions/_color_to_tool.md) — Convert color to closest drawing tool.

## Public Attributes

- `float line_width` — Line width for drawing in world units
- `float eraser_width` — Line width for eraser in world units
- `float point_distance_threshold` — Distance threshold to create new point (prevents too many points)
- `MeshInstance3D: map_mesh` — MeshInstance3D of map.
- `Tool _current_tool`
- `bool _is_drawing`
- `Array[Vector3] _current_stroke`
- `Array[Dictionary] _strokes`
- `Array[Dictionary] _scenario_strokes`
- `Vector3 _last_point`
- `TerrainRender _terrain_render`
- `Camera3D camera`
- `InteractionController interaction`
- `Array[Vector3] local_points`
- `Vector3 p1`
- `Vector3 p2`

## Signals

- `signal drawing_started` — Handles drawing on the map with pens and eraser.
- `signal drawing_updated`
- `signal drawing_cleared`

## Enumerations

- `enum Tool` — Drawing tool types

## Member Function Documentation

### _init_drawing_mesh

```gdscript
func _init_drawing_mesh() -> void
```

### _process

```gdscript
func _process(_delta: float) -> void
```

### _update_current_tool

```gdscript
func _update_current_tool() -> void
```

### _input

```gdscript
func _input(event: InputEvent) -> void
```

### _start_drawing

```gdscript
func _start_drawing() -> void
```

### _end_drawing

```gdscript
func _end_drawing() -> void
```

### _erase_at_point

```gdscript
func _erase_at_point(erase_point: Vector3) -> void
```

Erase strokes at a single point

### _split_into_segments

```gdscript
func _split_into_segments(surviving_points: Array[Vector3], original_points: Array) -> Array
```

Split points into continuous segments by detecting gaps in the original sequence

### _update_drawing_mesh

```gdscript
func _update_drawing_mesh() -> void
```

### _get_tool_color

```gdscript
func _get_tool_color(tool: Tool) -> Color
```

### _project_mouse_to_map

```gdscript
func _project_mouse_to_map(mouse_pos: Vector2) -> Variant
```

### set_tool

```gdscript
func set_tool(tool: Tool) -> void
```

Set the current drawing tool

### get_tool

```gdscript
func get_tool() -> Tool
```

Get the current drawing tool

### has_drawing

```gdscript
func has_drawing() -> bool
```

Check if any drawing has been made

### clear_all

```gdscript
func clear_all() -> void
```

Clear all drawings

### get_stroke_count

```gdscript
func get_stroke_count() -> int
```

Get total number of strokes drawn

### load_scenario_drawings

```gdscript
func load_scenario_drawings(scenario: ScenarioData, terrain_renderer: TerrainRender) -> void
```

Load scenario drawings and render them.
`scenario` ScenarioData with drawings to render.
`terrain_renderer` TerrainRender for coordinate conversion.

### _convert_scenario_stroke

```gdscript
func _convert_scenario_stroke(drawing: ScenarioDrawingStroke) -> Dictionary
```

Convert a ScenarioDrawingStroke to internal stroke format.
`drawing` ScenarioDrawingStroke from scenario.
[return] Dictionary with tool and points, or null if conversion fails.

### _terrain_to_world

```gdscript
func _terrain_to_world(pos_m: Vector2) -> Variant
```

Convert terrain 2D position to 3D world position on the map.
`pos_m` Terrain position in meters.
[return] World position as Vector3, or null if conversion fails.

### _color_to_tool

```gdscript
func _color_to_tool(color: Color) -> Tool
```

Convert color to closest drawing tool.
`color` Stroke color.
[return] Tool enum value.

## Member Data Documentation

### line_width

```gdscript
var line_width: float
```

Decorators: `@export`

Line width for drawing in world units

### eraser_width

```gdscript
var eraser_width: float
```

Decorators: `@export`

Line width for eraser in world units

### point_distance_threshold

```gdscript
var point_distance_threshold: float
```

Decorators: `@export`

Distance threshold to create new point (prevents too many points)

### map_mesh

```gdscript
var map_mesh: MeshInstance3D:
```

MeshInstance3D of map.

### _current_tool

```gdscript
var _current_tool: Tool
```

### _is_drawing

```gdscript
var _is_drawing: bool
```

### _current_stroke

```gdscript
var _current_stroke: Array[Vector3]
```

### _strokes

```gdscript
var _strokes: Array[Dictionary]
```

### _scenario_strokes

```gdscript
var _scenario_strokes: Array[Dictionary]
```

### _last_point

```gdscript
var _last_point: Vector3
```

### _terrain_render

```gdscript
var _terrain_render: TerrainRender
```

### camera

```gdscript
var camera: Camera3D
```

### interaction

```gdscript
var interaction: InteractionController
```

### local_points

```gdscript
var local_points: Array[Vector3]
```

### p1

```gdscript
var p1: Vector3
```

### p2

```gdscript
var p2: Vector3
```

## Signal Documentation

### drawing_started

```gdscript
signal drawing_started
```

Handles drawing on the map with pens and eraser.

Tracks which drawing tool is held and renders lines when the player
holds left click. Drawings are session-only and cleared on mission end.

### drawing_updated

```gdscript
signal drawing_updated
```

### drawing_cleared

```gdscript
signal drawing_cleared
```

## Enumeration Type Documentation

### Tool

```gdscript
enum Tool
```

Drawing tool types
