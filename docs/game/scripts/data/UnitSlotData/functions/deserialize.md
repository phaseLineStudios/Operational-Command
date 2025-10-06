# UnitSlotData::deserialize Function Reference

*Defined at:* `scripts/data/UnitSlotData.gd` (lines 25–41)</br>
*Belongs to:* [UnitSlotData](../UnitSlotData.md)

**Signature**

```gdscript
func deserialize(data: Variant) -> UnitSlotData
```

## Description

Deserialize data from JSON

## Source

```gdscript
static func deserialize(data: Variant) -> UnitSlotData:
	if typeof(data) != TYPE_DICTIONARY:
		return null

	var inst := UnitSlotData.new()
	inst.key = data.get("key", inst.key)
	inst.title = data.get("title", inst.title)
	inst.start_position = ContentDB.v2_from(data.get("start_position", inst.start_position))

	var roles = data.get("allowed_roles", inst.allowed_roles)
	if typeof(roles) == TYPE_ARRAY:
		var tmp: Array[String] = []
		for r in roles:
			tmp.append(str(r))
		inst.allowed_roles = tmp

	return inst
```
