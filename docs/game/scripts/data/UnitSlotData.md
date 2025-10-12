# UnitSlotData Class Reference

*File:* `scripts/data/UnitSlotData.gd`
*Class name:* `UnitSlotData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitSlotData
extends Resource
```

## Public Member Functions

- [`func serialize() -> Dictionary`](UnitSlotData/functions/serialize.md) — Serialize data to JSON
- [`func deserialize(data: Variant) -> UnitSlotData`](UnitSlotData/functions/deserialize.md) — Deserialize data from JSON

## Public Attributes

- `String key` — A unique key identifying this slot.
- `String title` — A human-readable title for the slot.
- `String callsign` — Ingame Callsign
- `Array[String] allowed_roles` — A list of allowed roles
- `Vector2 start_position` — Unit starting position

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

Decorators: `@export`

A unique key identifying this slot.

### title

```gdscript
var title: String
```

Decorators: `@export`

A human-readable title for the slot.

### callsign

```gdscript
var callsign: String
```

Decorators: `@export`

Ingame Callsign

### allowed_roles

```gdscript
var allowed_roles: Array[String]
```

Decorators: `@export`

A list of allowed roles

### start_position

```gdscript
var start_position: Vector2
```

Decorators: `@export`

Unit starting position
