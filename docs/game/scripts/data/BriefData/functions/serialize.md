# BriefData::serialize Function Reference

*Defined at:* `scripts/data/BriefData.gd` (lines 43–81)</br>
*Belongs to:* [BriefData](../../BriefData.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Description

Serializes briefing data to JSON

## Source

```gdscript
func serialize() -> Dictionary:
	var items: Array = []
	for it in board_items:
		items.append(it.serialize())

	var objs: Array = []
	for obj in frag_objectives:
		objs.append(obj.serialize())

	return {
		"id": id,
		"title": title,
		"situation":
		{
			"enemy": frag_enemy,
			"friendly": frag_friendly,
			"terrain": frag_terrain,
			"weather": frag_weather,
			"start_time": frag_start_time
		},
		"mission": {"statement": frag_mission, "objectives": objs},
		"execution": frag_execution,
		"admin_logi": frago_logi,
		"intel_board":
		{
			"board_texture_path":
			(
				(
					board_texture.resource_path as Variant
					if board_texture and board_texture.resource_path != ""
					else null
				)
				as Variant
			),
			"items": items
		}
	}
```
