# BriefItemData Class Reference

*File:* `scripts/data/BriefItemData.gd`
*Class name:* `BriefItemData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name BriefItemData
extends Resource
```

## Public Member Functions

- [`func serialize() -> Dictionary`](BriefItemData/functions/serialize.md) — Serializes Briefing Item to JSON
- [`func deserialize(data: Variant) -> BriefItemData`](BriefItemData/functions/deserialize.md) — Deserializes briefing item from JSON

## Public Attributes

- `String id` — Unique identifier for this briefing item
- `String title` — Human-readable title of the briefing item
- `ItemType type` — Type of the briefing item
- `resource` — Path to the resource backing this item
- `Vector2 board_position` — Position of the item on the briefing board.

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

Decorators: `@export`

Unique identifier for this briefing item

### title

```gdscript
var title: String
```

Decorators: `@export`

Human-readable title of the briefing item

### type

```gdscript
var type: ItemType
```

Decorators: `@export`

Type of the briefing item

### resource

```gdscript
var resource
```

Decorators: `@export_file("*.* ; Any Resource")`

Path to the resource backing this item

### board_position

```gdscript
var board_position: Vector2
```

Decorators: `@export`

Position of the item on the briefing board.

## Enumeration Type Documentation

### ItemType

```gdscript
enum ItemType
```

Types of briefing item
