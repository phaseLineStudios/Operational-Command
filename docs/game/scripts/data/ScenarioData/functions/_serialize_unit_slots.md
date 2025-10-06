# ScenarioData::_serialize_unit_slots Function Reference

*Defined at:* `scripts/data/ScenarioData.gd` (lines 227–237)</br>
*Belongs to:* [ScenarioData](../ScenarioData.md)

**Signature**

```gdscript
func _serialize_unit_slots(arr: Array) -> Array
```

## Source

```gdscript
func _serialize_unit_slots(arr: Array) -> Array:
	var out: Array = []
	for item in arr:
		if item == null:
			out.append(null)
			continue

		out.append(item.serialize())
	return out
```
