# ContentDB::list_unit_categories Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 404–416)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func list_unit_categories() -> Array[UnitCategoryData]
```

## Description

List all unit categories

## Source

```gdscript
func list_unit_categories() -> Array[UnitCategoryData]:
	var camps := get_all_objects("unit_categories")
	if camps.is_empty():
		return []

	var out: Array[UnitCategoryData] = []
	for item in camps:
		var res := UnitCategoryData.deserialize(item)
		if res != null:
			out.append(res)
	return out
```
