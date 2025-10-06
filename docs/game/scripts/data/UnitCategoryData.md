# UnitCategoryData Class Reference

*File:* `scripts/data/UnitCategoryData.gd`
*Class name:* `UnitCategoryData`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name UnitCategoryData
extends Resource
```

## Brief

Unique key identifying this category

## Detailed Description

Unit Category Title

Unit Category Editor Icon

## Public Member Functions

- [`func serialize() -> Dictionary`](UnitCategoryData/functions/serialize.md) — Serialize data to JSON
- [`func deserialize(data: Variant) -> UnitCategoryData`](UnitCategoryData/functions/deserialize.md) — Deserialize data from JSON

## Public Attributes

- `String id`
- `String title`
- `Texture2D editor_icon`

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

### title

```gdscript
var title: String
```

### editor_icon

```gdscript
var editor_icon: Texture2D
```
