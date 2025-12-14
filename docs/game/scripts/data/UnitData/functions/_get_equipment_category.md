# UnitData::_get_equipment_category Function Reference

*Defined at:* `scripts/data/UnitData.gd` (lines 496–507)</br>
*Belongs to:* [UnitData](../../UnitData.md)

**Signature**

```gdscript
func _get_equipment_category(category_name: String) -> Dictionary
```

## Description

Lookup an equipment category while tolerating mixed-case keys.

## Source

```gdscript
func _get_equipment_category(category_name: String) -> Dictionary:
	if typeof(equipment) != TYPE_DICTIONARY or category_name == "":
		return {}
	var lookup := category_name.to_lower()
	if equipment.has(lookup) and typeof(equipment[lookup]) == TYPE_DICTIONARY:
		return equipment[lookup]
	for key in equipment.keys():
		if String(key).to_lower() == lookup and typeof(equipment[key]) == TYPE_DICTIONARY:
			return equipment[key]
	return {}
```
