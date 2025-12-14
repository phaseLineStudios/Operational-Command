# ContentDB::list_units Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 344–357)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_units() -> Array[UnitData]
```

## Description

List all units

## Source

```gdscript
func list_units() -> Array[UnitData]:
	var camps := get_all_objects("units")
	if camps.is_empty():
		return []

	var out: Array[UnitData] = []
	for item in camps:
		var res := UnitData.deserialize(item)
		if res != null:
			res.compute_attack_power(AMMO_DAMAGE_CONFIG)
			out.append(res)
	return out
```
