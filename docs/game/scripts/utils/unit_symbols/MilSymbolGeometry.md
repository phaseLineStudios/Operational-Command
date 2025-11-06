# MilSymbolGeometry Class Reference

*File:* `scripts/utils/unit_symbols/MilSymbolGeometry.gd`
*Class name:* `MilSymbolGeometry`
*Inherits:* `RefCounted`

## Synopsis

```gdscript
class_name MilSymbolGeometry
extends RefCounted
```

## Brief

Base geometry definitions for military symbol frames

## Detailed Description

Defines the frame shapes for different affiliations and domains

Create arc points for curved shapes

## Public Member Functions

- [`func get_ground_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]`](MilSymbolGeometry/functions/get_ground_frame.md) — Get frame points for ground units based on affiliation
- [`func get_air_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]`](MilSymbolGeometry/functions/get_air_frame.md) — Get frame points for air units based on affiliation
- [`func get_sea_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]`](MilSymbolGeometry/functions/get_sea_frame.md) — Get frame points for sea units based on affiliation
- [`func get_frame_bounds(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Rect2`](MilSymbolGeometry/functions/get_frame_bounds.md) — Get bounding box for a frame (in 200x200 coordinate space)
- [`func is_circle_frame(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> bool`](MilSymbolGeometry/functions/is_circle_frame.md) — Check if frame should use circle drawing
- [`func get_circle_params(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Array`](MilSymbolGeometry/functions/get_circle_params.md) — Get circle parameters [center_x, center_y, radius]

## Public Attributes

- `Array[Vector2] points`
- `float angle_step`
- `float angle`
- `float x`
- `float y`

## Enumerations

- `enum Domain` — Domain types (determines base shape)

## Member Function Documentation

### get_ground_frame

```gdscript
func get_ground_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]
```

Get frame points for ground units based on affiliation
Returns an array of Vector2 points in 200x200 coordinate space

### get_air_frame

```gdscript
func get_air_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]
```

Get frame points for air units based on affiliation

### get_sea_frame

```gdscript
func get_sea_frame(affiliation: MilSymbol.UnitAffiliation) -> Array[Vector2]
```

Get frame points for sea units based on affiliation

### get_frame_bounds

```gdscript
func get_frame_bounds(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Rect2
```

Get bounding box for a frame (in 200x200 coordinate space)

### is_circle_frame

```gdscript
func is_circle_frame(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> bool
```

Check if frame should use circle drawing

### get_circle_params

```gdscript
func get_circle_params(domain: Domain, affiliation: MilSymbol.UnitAffiliation) -> Array
```

Get circle parameters [center_x, center_y, radius]

## Member Data Documentation

### points

```gdscript
var points: Array[Vector2]
```

### angle_step

```gdscript
var angle_step: float
```

### angle

```gdscript
var angle: float
```

### x

```gdscript
var x: float
```

### y

```gdscript
var y: float
```

## Enumeration Type Documentation

### Domain

```gdscript
enum Domain
```

Domain types (determines base shape)
