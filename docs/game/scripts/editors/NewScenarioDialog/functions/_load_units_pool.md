# NewScenarioDialog::_load_units_pool Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 200–216)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _load_units_pool() -> void
```

## Description

Load all units from ContentDB and build id map.

## Source

```gdscript
func _load_units_pool() -> void:
	_all_units = []
	_unit_by_id.clear()
	if typeof(ContentDB) == TYPE_NIL:
		push_warning("ContentDB singleton not found; pool is empty.")
		return
	var arr := []
	if ContentDB.has_method("list_units"):
		arr = ContentDB.list_units()
	elif ContentDB.has_method("get_all_units"):
		arr = ContentDB.get_all_units()
	for u in arr:
		if u is UnitData and String(u.id) != "":
			_all_units.append(u)
			_unit_by_id[String(u.id)] = u
```
