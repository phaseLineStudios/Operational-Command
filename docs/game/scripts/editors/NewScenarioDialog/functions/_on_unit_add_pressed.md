# NewScenarioDialog::_on_unit_add_pressed Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 351–362)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_unit_add_pressed() -> void
```

## Description

Add by ItemList selection (pool -> selected).

## Source

```gdscript
func _on_unit_add_pressed() -> void:
	var items := unit_pool.get_selected_items()
	if items.is_empty():
		return
	var ids: Array[String] = []
	for i in items:
		var md: Variant = unit_pool.get_item_metadata(i)
		if typeof(md) == TYPE_DICTIONARY and md.has("id"):
			ids.append(String(md["id"]))
	_add_units_by_ids(ids)
```
