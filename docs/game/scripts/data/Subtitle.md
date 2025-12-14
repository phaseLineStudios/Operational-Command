# Subtitle Class Reference

*File:* `scripts/data/Subtitle.gd`
*Class name:* `Subtitle`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name Subtitle
extends Resource
```

## Brief

Inner class representing a single subtitle entry

## Public Member Functions

- [`func _init(p_start: float = 0.0, p_end: float = 0.0, p_text: String = "") -> void`](Subtitle/functions/_init.md)
- [`func serialize() -> Dictionary`](Subtitle/functions/serialize.md) — Serialize subtitle to dictionary
- [`func deserialize(data: Dictionary) -> Subtitle`](Subtitle/functions/deserialize.md) — Deserialize subtitle from dictionary

## Public Attributes

- `float start_time` — Start time in seconds
- `float end_time` — End time in seconds
- `String text` — Subtitle text content

## Member Function Documentation

### _init

```gdscript
func _init(p_start: float = 0.0, p_end: float = 0.0, p_text: String = "") -> void
```

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize subtitle to dictionary

### deserialize

```gdscript
func deserialize(data: Dictionary) -> Subtitle
```

Deserialize subtitle from dictionary

## Member Data Documentation

### start_time

```gdscript
var start_time: float
```

Decorators: `@export`

Start time in seconds

### end_time

```gdscript
var end_time: float
```

Decorators: `@export`

End time in seconds

### text

```gdscript
var text: String
```

Decorators: `@export`

Subtitle text content
