# UnitAutoResponses::_on_contact_reported Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 524–542)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _on_contact_reported(attacker_id: String, defender_id: String) -> void
```

## Description

Handle contact reported signal (NEW contact only).

## Source

```gdscript
func _on_contact_reported(attacker_id: String, defender_id: String) -> void:
	var spotter: ScenarioUnit = _units_by_id.get(attacker_id)
	if not spotter or not spotter.playable:
		return

	var contact_unit: ScenarioUnit = _units_by_id.get(defender_id)
	if not contact_unit or contact_unit.is_dead():
		return

	if not _active_contacts.has(attacker_id):
		_active_contacts[attacker_id] = []

	var contacts: Array = _active_contacts[attacker_id]
	if defender_id not in contacts:
		contacts.append(defender_id)
		_report_contact_spotted(attacker_id, defender_id)
		_spawn_contact_counter(defender_id)
```
