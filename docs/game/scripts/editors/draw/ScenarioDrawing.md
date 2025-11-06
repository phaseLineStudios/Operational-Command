# ScenarioDrawing Class Reference

*File:* `scripts/editors/draw/ScenarioDrawing.gd`
*Class name:* `ScenarioDrawing`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name ScenarioDrawing
extends Resource
```

## Public Member Functions

- [`func serialize_base() -> Dictionary`](ScenarioDrawing/functions/serialize_base.md) — Serialize to JSON-friendly Dictionary.
- [`func deserialize_base(d: Dictionary) -> void`](ScenarioDrawing/functions/deserialize_base.md) — Apply common fields from Dictionary.
- [`func deserialize(d: Dictionary) -> ScenarioDrawing`](ScenarioDrawing/functions/deserialize.md) — Factory from Dictionary.

## Public Attributes

- `String id`
- `bool visible`
- `int layer`
- `int order` — Creation order for stable z-sort within a layer.

## Enumerations

- `enum Kind` — Base class for scenario drawings (stroke or stamp). **Experimental**

## Member Function Documentation

### serialize_base

```gdscript
func serialize_base() -> Dictionary
```

Serialize to JSON-friendly Dictionary.
[return] Dictionary with common fields.

### deserialize_base

```gdscript
func deserialize_base(d: Dictionary) -> void
```

Apply common fields from Dictionary.
`d` Source dictionary.

### deserialize

```gdscript
func deserialize(d: Dictionary) -> ScenarioDrawing
```

Factory from Dictionary.
`d` Serialized object.
[return] ScenarioDrawing or null.

## Member Data Documentation

### id

```gdscript
var id: String
```

### visible

```gdscript
var visible: bool
```

### layer

```gdscript
var layer: int
```

### order

```gdscript
var order: int
```

Decorators: `@export`

Creation order for stable z-sort within a layer.

## Enumeration Type Documentation

### Kind

```gdscript
enum Kind
```

> **Experimental**

Base class for scenario drawings (stroke or stamp).
