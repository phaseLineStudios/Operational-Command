# UnitCategoryData::serialize Function Reference

*Defined at:* `scripts/data/UnitCategoryData.gd` (lines 13–28)</br>
*Belongs to:* [UnitCategoryData](../../UnitCategoryData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serialize data to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"editor_icon_path":
		(
			(
				editor_icon.resource_path as Variant
				if editor_icon and editor_icon.resource_path != ""
				else null
			)
			as Variant
		),
	}
```
