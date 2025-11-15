# ContentDB::get_unit_categories Function Reference

*Defined at:* `scripts/core/ContentDB.gd` (lines 389–397)</br>
*Belongs to:* [ContentDB](../../ContentDB.md)

**Signature**

```gdscript
func get_unit_categories(ids: Array) -> Array[UnitCategoryData]
```

## Description

Get unit categories by IDs

## Source

```gdscript
func get_unit_categories(ids: Array) -> Array[UnitCategoryData]:
	var out: Array[UnitCategoryData] = []
	for raw in ids:
		var u: UnitCategoryData = get_unit_category(String(raw))
		if u != null:
			out.append(u)
	return out
```
