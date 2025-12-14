# NewScenarioDialog::_add_units_by_ids Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 391–408)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _add_units_by_ids(ids: Array[String]) -> void
```

## Description

Append units by ids (dedup).

## Source

```gdscript
func _add_units_by_ids(ids: Array[String]) -> void:
	var need_refresh := false
	for id in ids:
		if not _unit_by_id.has(id):
			continue
		var u: UnitData = _unit_by_id[id]
		var already := false
		for ex in _selected_units:
			if String(ex.id) == id:
				already = true
				break
		if not already:
			_selected_units.append(u)
			need_refresh = true
	if need_refresh:
		_refresh_unit_lists()
```
