# ScenarioDrawingStamp Class Reference

*File:* `scripts/editors/draw/ScenarioDrawingStamp.gd`
*Class name:* `ScenarioDrawingStamp`
*Inherits:* `ScenarioDrawing`

## Synopsis

```gdscript
class_name ScenarioDrawingStamp
extends ScenarioDrawing
```

## Brief

Texture stamp placed at world position.

## Public Member Functions

- [`func serialize() -> Dictionary`](ScenarioDrawingStamp/functions/serialize.md) — Serialize stamp.
- [`func deserialize(d: Dictionary) -> ScenarioDrawingStamp`](ScenarioDrawingStamp/functions/deserialize.md) — Deserialize stamp.

## Public Attributes

- `String texture_path` — Texture path (res://).
- `Color modulate` — Tint color.
- `float opacity` — Opacity multiplier [0..1].
- `Vector2 position_m` — Center position in meters.
- `float scale` — Screen-space uniform scale.
- `float rotation_deg` — Rotation in degrees (clockwise).
- `String label` — Optional text label shown to the right of the stamp.

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize stamp.
[return] Dictionary.

### deserialize

```gdscript
func deserialize(d: Dictionary) -> ScenarioDrawingStamp
```

Deserialize stamp.
`d` Dictionary.
[return] ScenarioDrawingStamp.

## Member Data Documentation

### texture_path

```gdscript
var texture_path: String
```

Decorators: `@export_file("*.png", "*.jpg", "*.webp")`

Texture path (res://).

### modulate

```gdscript
var modulate: Color
```

Decorators: `@export`

Tint color.

### opacity

```gdscript
var opacity: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Opacity multiplier [0..1].

### position_m

```gdscript
var position_m: Vector2
```

Decorators: `@export`

Center position in meters.

### scale

```gdscript
var scale: float
```

Decorators: `@export_range(0.05, 10.0, 0.01)`

Screen-space uniform scale.

### rotation_deg

```gdscript
var rotation_deg: float
```

Decorators: `@export_range(-360.0, 360.0, 0.1)`

Rotation in degrees (clockwise).

### label

```gdscript
var label: String
```

Decorators: `@export`

Optional text label shown to the right of the stamp.
