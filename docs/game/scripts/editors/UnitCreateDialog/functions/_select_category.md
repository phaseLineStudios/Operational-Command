# UnitCreateDialog::_select_category Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 430–440)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _select_category(cat: UnitCategoryData) -> void
```

## Description

Select editor category.

## Source

```gdscript
func _select_category(cat: UnitCategoryData) -> void:
	if cat == null:
		return
	for i in _category_ob.item_count:
		var meta = _category_ob.get_item_metadata(i)
		if typeof(meta) == TYPE_DICTIONARY and meta.has("id"):
			if String(meta["id"]) == String(cat.get("id") if cat.has_method("get") else cat.id):
				_category_ob.select(i)
				return
```
