# StampLayer Class Reference

*File:* `scripts/terrain/StampLayer.gd`
*Class name:* `StampLayer`
*Inherits:* `Control`

## Synopsis

```gdscript
class_name StampLayer
extends Control
```

## Public Member Functions

- [`func _ready() -> void`](StampLayer/functions/_ready.md)
- [`func load_stamps(stamps: Array) -> void`](StampLayer/functions/load_stamps.md) — Load stamps from scenario data.
- [`func clear_stamps() -> void`](StampLayer/functions/clear_stamps.md) — Clear all stamps.
- [`func _draw() -> void`](StampLayer/functions/_draw.md)
- [`func _draw_stamp(stamp: ScenarioDrawingStamp, _terrain_render: TerrainRender) -> void`](StampLayer/functions/_draw_stamp.md) — Draw a single stamp.
- [`func _draw_stamp_label(text: String, pos_px: Vector2, offset_x: float, color: Color) -> void`](StampLayer/functions/_draw_stamp_label.md) — Draw label next to stamp.
- [`func _get_terrain_render() -> TerrainRender`](StampLayer/functions/_get_terrain_render.md) — Get parent TerrainRender node.

## Public Attributes

- `Array[ScenarioDrawingStamp] _stamps` — Renders scenario stamps (drawings) on the terrain in 2D map space.
- `Dictionary _texture_cache`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### load_stamps

```gdscript
func load_stamps(stamps: Array) -> void
```

Load stamps from scenario data.
`stamps` Array of ScenarioDrawingStamp to render.

### clear_stamps

```gdscript
func clear_stamps() -> void
```

Clear all stamps.

### _draw

```gdscript
func _draw() -> void
```

### _draw_stamp

```gdscript
func _draw_stamp(stamp: ScenarioDrawingStamp, _terrain_render: TerrainRender) -> void
```

Draw a single stamp.

### _draw_stamp_label

```gdscript
func _draw_stamp_label(text: String, pos_px: Vector2, offset_x: float, color: Color) -> void
```

Draw label next to stamp.

### _get_terrain_render

```gdscript
func _get_terrain_render() -> TerrainRender
```

Get parent TerrainRender node.

## Member Data Documentation

### _stamps

```gdscript
var _stamps: Array[ScenarioDrawingStamp]
```

Renders scenario stamps (drawings) on the terrain in 2D map space.

### _texture_cache

```gdscript
var _texture_cache: Dictionary
```
