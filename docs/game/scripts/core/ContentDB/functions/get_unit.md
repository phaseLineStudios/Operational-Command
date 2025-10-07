# ContentDB::get_unit Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 283–290)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_unit(id: String) -> UnitData
```

## Description

Units helpers.
Get unit by ID

## Source

```gdscript
func get_unit(id: String) -> UnitData:
	var d := get_object("units", id)
	if d.is_empty():
		push_warning("Unit not found: %s" % id)
		return null
	return UnitData.deserialize(d)
```
