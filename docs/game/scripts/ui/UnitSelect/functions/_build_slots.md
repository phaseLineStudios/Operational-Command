# UnitSelect::_build_slots Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 102–125)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _build_slots() -> void
```

## Description

Build slot list from mission slot definitions

## Source

```gdscript
func _build_slots() -> void:
	_slot_data.clear()
	_total_slots = 0

	var defs: Array[UnitSlotData] = Game.current_scenario.unit_slots
	for def in defs:
		var title := String(def.title)
		var key := String(def.key)

		var allowed_roles: Array = def.allowed_roles
		var slot_id := "%s#%d" % [key, _total_slots + 1]
		_slot_data[slot_id] = {
			"key": key,
			"title": title,
			"allowed_roles": allowed_roles.duplicate(),
			"index": _total_slots + 1,
			"max": defs.size(),
			"assigned": ""
		}
		_total_slots += 1

	_slots_list.build_from_slots(_slot_data)
```
