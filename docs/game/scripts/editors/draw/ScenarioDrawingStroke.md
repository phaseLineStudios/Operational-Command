# ScenarioDrawingStroke Class Reference

*File:* `scripts/editors/draw/ScenarioDrawingStroke.gd`
*Class name:* `ScenarioDrawingStroke`
*Inherits:* `ScenarioDrawing`

## Synopsis

```gdscript
class_name ScenarioDrawingStroke
extends ScenarioDrawing
```

## Brief

Freehand polyline stored in world meters.

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioDrawingStroke/functions/serialize.md) — Serialize stroke.
- [`func deserialize(d: Dictionary) -> ScenarioDrawingStroke`](ScenarioDrawingStroke/functions/deserialize.md) — Deserialize stroke.

## Public Attributes

- `Color color` — Stroke color (RGBA).
- `float width_px` — Stroke width in pixels (screen-space).
- `float opacity` — Opacity multiplier [0..1].
- `PackedVector2Array points_m` — World points (meters).

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize stroke.
[return] Dictionary.

### deserialize

```gdscript
func deserialize(d: Dictionary) -> ScenarioDrawingStroke
```

Deserialize stroke.
`d` Dictionary.
[return] ScenarioDrawingStroke.

## Member Data Documentation

### color

```gdscript
var color: Color
```

Decorators: `@export`

Stroke color (RGBA).

### width_px

```gdscript
var width_px: float
```

Decorators: `@export`

Stroke width in pixels (screen-space).

### opacity

```gdscript
var opacity: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Opacity multiplier [0..1].

### points_m

```gdscript
var points_m: PackedVector2Array
```

Decorators: `@export`

World points (meters).
