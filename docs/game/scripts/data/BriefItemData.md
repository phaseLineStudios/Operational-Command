# BriefItemData Class Reference

*File:* `scripts/data/BriefItemData.gd`
*Class name:* `BriefItemData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name BriefItemData
extends Resource
```

## Brief

Unique identifier for this briefing item

Human-readable title of the briefing item

Path to the resource backing this item

Position of the item on the briefing board.

## Public Member Functions

- [`func serialize() -> Dictionary`](BriefItemData/functions/serialize.md) — Serializes Briefing Item to JSON
- [`func deserialize(data: Variant) -> BriefItemData`](BriefItemData/functions/deserialize.md) — Deserializes briefing item from JSON

## Public Attributes

- `String id`
- `String title`
- `ItemType type` — Type of the briefing item
- `Vector2 board_position`

## Enumerations

- `enum ItemType` — Types of briefing item

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serializes Briefing Item to JSON

### deserialize

```gdscript
func deserialize(data: Variant) -> BriefItemData
```

Deserializes briefing item from JSON

## Member Data Documentation

### id

```gdscript
var id: String
```

### title

```gdscript
var title: String
```

### type

```gdscript
var type: ItemType
```

Type of the briefing item

### board_position

```gdscript
var board_position: Vector2
```

## Enumeration Type Documentation

### ItemType

```gdscript
enum ItemType
```

Types of briefing item
