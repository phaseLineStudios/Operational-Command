# ScenarioData::_deserialize_unit_slots Function Reference

*Defined at:* `scripts/data/ScenarioData.gd` (lines 267–281)</br>
*Belongs to:* [ScenarioData](../../ScenarioData.md)

**Signature**

```gdscript
func _deserialize_unit_slots(payload: Variant) -> Array[UnitSlotData]
```

## Source

```gdscript
static func _deserialize_unit_slots(payload: Variant) -> Array[UnitSlotData]:
	var out: Array[UnitSlotData] = []
	if typeof(payload) != TYPE_ARRAY:
		return out
	for it in payload:
		var slot: UnitSlotData = null
		if it is UnitSlotData:
			slot = it
		elif typeof(it) == TYPE_DICTIONARY:
			slot = UnitSlotData.deserialize(it)
		if slot != null:
			out.append(slot)
	return out
```
