# NewScenarioDialog::_on_unit_remove_pressed Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 272–283)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_unit_remove_pressed() -> void
```

## Description

Remove by ItemList selection (selected -> pool).

## Source

```gdscript
func _on_unit_remove_pressed() -> void:
	var items := unit_selected.get_selected_items()
	if items.is_empty():
		return
	var ids: Array[String] = []
	for i in items:
		var md: Variant = unit_selected.get_item_metadata(i)
		if typeof(md) == TYPE_DICTIONARY and md.has("id"):
			ids.append(String(md["id"]))
	_remove_units_by_ids(ids)
```
