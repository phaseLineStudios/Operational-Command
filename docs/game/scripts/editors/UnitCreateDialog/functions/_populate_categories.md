# UnitCreateDialog::_populate_categories Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 365–377)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _populate_categories() -> void
```

## Description

Populate editor categories.

## Source

```gdscript
func _populate_categories() -> void:
	_category_ob.clear()
	_cat_items.clear()
	var cats := ContentDB.list_unit_categories()
	for c in cats:
		var cat_title := c.title
		var id := c.id
		var idx := _category_ob.item_count
		_category_ob.add_item(cat_title, idx)
		_category_ob.set_item_metadata(idx, {"id": id, "res": c})
	_cat_items = cats
```
