# BriefItemData::serialize Function Reference

*Defined at:* `scripts/data/BriefItemData.gd` (lines 20–34)</br>
*Belongs to:* [BriefItemData](../BriefItemData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serializes Briefing Item to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"type": int(type),
		"resource_path":
		(
			resource
			if typeof(resource) == TYPE_STRING
			else (resource.resource_path if resource and resource.resource_path != "" else null)
		),
		"board_position": {"x": board_position.x, "y": board_position.y}
	}
```
