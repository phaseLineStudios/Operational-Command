# UnitAutoResponses::_check_contact_changes Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 449–459)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _check_contact_changes(unit_id: String, _prev: Dictionary, _current: Dictionary) -> void
```

## Description

Check for contact changes (enemies spotted/lost).

## Source

```gdscript
func _check_contact_changes(unit_id: String, _prev: Dictionary, _current: Dictionary) -> void:
	var current_contacts := _get_current_contacts_for_unit(unit_id)
	var prev_tracked: Array = _active_contacts.get(unit_id, []).duplicate()

	for prev_enemy_id in prev_tracked:
		if prev_enemy_id not in current_contacts:
			_report_contact_lost(unit_id, prev_enemy_id)

	_active_contacts[unit_id] = current_contacts.duplicate()
```
