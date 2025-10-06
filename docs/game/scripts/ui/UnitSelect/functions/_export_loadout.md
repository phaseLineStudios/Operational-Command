# UnitSelect::_export_loadout Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 408–414)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _export_loadout() -> Dictionary
```

## Description

Export current mission loadout as dictionary

## Source

```gdscript
func _export_loadout() -> Dictionary:
	## Returns { mission_id, points_used, assignments: [{slot_id, unit_id}] }
	var arr: Array = []
	for sid: String in _slot_data.keys():
		var unit_id: StringName = _slot_data[sid]["assigned"]
		arr.append({"slot_id": sid, "slot_key": _slot_data[sid]["key"], "unit_id": String(unit_id)})
	return {"mission_id": Game.current_scenario.id, "points_used": _used_points, "assignments": arr}
```
