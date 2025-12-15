# UnitAutoResponses::_connect_unit_signals Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 277–284)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _connect_unit_signals() -> void
```

## Description

Connect to unit-specific signals (move_blocked, etc.)

## Source

```gdscript
func _connect_unit_signals() -> void:
	for unit_id in _units_by_id.keys():
		var unit = _units_by_id[unit_id]
		if unit and unit is ScenarioUnit:
			if not unit.move_blocked.is_connected(_on_unit_move_blocked):
				unit.move_blocked.connect(_on_unit_move_blocked.bind(unit_id))
```
