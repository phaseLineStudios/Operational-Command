# UnitSlotData Class Reference

*File:* `scripts/data/UnitSlotData.gd`
*Class name:* `UnitSlotData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitSlotData
extends Resource
```

## Brief

A unique key identifying this slot.

## Detailed Description

A human-readable title for the slot.

Unit starting position

## Public Member Functions

- [`func serialize() -> Dictionary`](UnitSlotData/functions/serialize.md) — Serialize data to JSON
- [`func deserialize(data: Variant) -> UnitSlotData`](UnitSlotData/functions/deserialize.md) — Deserialize data from JSON

## Public Attributes

- `String key`
- `String title`
- `Array[String] allowed_roles` — A list of allowed roles
- `Vector2 start_position`

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize data to JSON

### deserialize

```gdscript
func deserialize(data: Variant) -> UnitSlotData
```

Deserialize data from JSON

## Member Data Documentation

### key

```gdscript
var key: String
```

### title

```gdscript
var title: String
```

### allowed_roles

```gdscript
var allowed_roles: Array[String]
```

A list of allowed roles

### start_position

```gdscript
var start_position: Vector2
```
