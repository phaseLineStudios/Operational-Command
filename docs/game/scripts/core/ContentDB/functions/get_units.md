# ContentDB::get_units Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 292–300)</br>
*Belongs to:* [ContentDB](../ContentDB.md)

**Signature**

```gdscript
func get_units(ids: Array) -> Array[UnitData]
```

## Description

Get units by IDs

## Source

```gdscript
func get_units(ids: Array) -> Array[UnitData]:
	var out: Array[UnitData] = []
	for raw in ids:
		var u: UnitData = get_unit(String(raw))
		if u != null:
			out.append(u)
	return out
```
