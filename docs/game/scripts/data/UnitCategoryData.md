# UnitCategoryData Class Reference

*File:* `scripts/data/UnitCategoryData.gd`
*Class name:* `UnitCategoryData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitCategoryData
extends Resource
```

## Public Member Functions

- [`func serialize() -> Dictionary`](UnitCategoryData/functions/serialize.md) — Serialize data to JSON
- [`func deserialize(data: Variant) -> UnitCategoryData`](UnitCategoryData/functions/deserialize.md) — Deserialize data from JSON

## Public Attributes

- `String id` — Unique key identifying this category
- `String title` — Unit Category Title
- `Texture2D editor_icon` — Unit Category Editor Icon

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize data to JSON

### deserialize

```gdscript
func deserialize(data: Variant) -> UnitCategoryData
```

Deserialize data from JSON

## Member Data Documentation

### id

```gdscript
var id: String
```

Decorators: `@export`

Unique key identifying this category

### title

```gdscript
var title: String
```

Decorators: `@export`

Unit Category Title

### editor_icon

```gdscript
var editor_icon: Texture2D
```

Decorators: `@export`

Unit Category Editor Icon
