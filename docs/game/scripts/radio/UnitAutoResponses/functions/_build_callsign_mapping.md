# UnitAutoResponses::_build_callsign_mapping Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 261–271)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _build_callsign_mapping() -> void
```

## Description

Build callsign mapping from units dictionary.

## Source

```gdscript
func _build_callsign_mapping() -> void:
	_id_to_callsign.clear()

	for unit_id in _units_by_id.keys():
		var unit = _units_by_id[unit_id]
		if unit:
			_id_to_callsign[unit_id] = unit.callsign
		else:
			_id_to_callsign[unit_id] = unit_id
```
