# BriefItemData::deserialize Function Reference

*Defined at:* `scripts/data/BriefItemData.gd` (lines 36–57)</br>
*Belongs to:* [BriefItemData](../BriefItemData.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> BriefItemData
```

## Description

Deserializes briefing item from JSON

## Source

```gdscript
static func deserialize(data: Variant) -> BriefItemData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var b := BriefItemData.new()
	b.id = data.get("id", b.id)
	b.title = data.get("title", b.title)
	b.type = int(data.get("type", b.type)) as ItemType

	var res_path = data.get("resource_path", null)
	if res_path != null and typeof(res_path) == TYPE_STRING and res_path != "":
		var res := load(res_path)
		if res:
			b.resource = res

	var pos = data.get("board_position", null)
	if typeof(pos) == TYPE_DICTIONARY and pos.has("x") and pos.has("y"):
		b.board_position = Vector2(float(pos["x"]), float(pos["y"]))
	elif typeof(pos) == TYPE_ARRAY and pos.size() >= 2:
		b.board_position = Vector2(float(pos[0]), float(pos[1]))

	return b
```
