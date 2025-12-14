# NewScenarioDialog::_remove_units_by_ids Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 410–424)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _remove_units_by_ids(ids: Array[String]) -> void
```

## Description

Remove units by ids.

## Source

```gdscript
func _remove_units_by_ids(ids: Array[String]) -> void:
	if ids.is_empty():
		return
	var need_refresh := false
	var keep: Array[UnitData] = []
	for u in _selected_units:
		if String(u.id) in ids:
			need_refresh = true
			continue
		keep.append(u)
	_selected_units = keep
	if need_refresh:
		_refresh_unit_lists()
```
