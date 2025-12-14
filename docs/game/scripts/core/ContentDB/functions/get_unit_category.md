# ContentDB::get_unit_category Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 385–392)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_unit_category(id: String) -> UnitCategoryData
```

## Description

Unit Category helpers.
Get unit category by ID

## Source

```gdscript
func get_unit_category(id: String) -> UnitCategoryData:
	var d := get_object("unit_categories", id)
	if d.is_empty():
		push_warning("Unit category not found: %s" % id)
		return null
	return UnitCategoryData.deserialize(d)
```
