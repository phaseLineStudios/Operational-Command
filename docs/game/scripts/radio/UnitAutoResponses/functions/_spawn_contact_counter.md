# UnitAutoResponses::_spawn_contact_counter Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 643–679)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _spawn_contact_counter(contact_id: String) -> void
```

- **contact_id**: Enemy unit ID to spawn counter for.

## Description

Spawn a unit counter for a spotted contact.

## Source

```gdscript
func _spawn_contact_counter(contact_id: String) -> void:
	if _spotted_contacts.get(contact_id, false):
		return

	if not _counter_controller:
		return

	var contact_unit: ScenarioUnit = _units_by_id.get(contact_id)
	if not contact_unit:
		return

	var affiliation := MilSymbol.UnitAffiliation.ENEMY
	if contact_unit:
		affiliation = _parse_unit_affiliation(contact_unit.affiliation)

	var unit_type := MilSymbol.UnitType.INFANTRY
	if contact_unit:
		unit_type = contact_unit.unit.type

	var unit_size := MilSymbol.UnitSize.PLATOON
	if contact_unit:
		unit_size = contact_unit.unit.size

	var callsign: String = contact_unit.callsign
	var pos_m: Vector2 = contact_unit.position_m

	_counter_controller.spawn_counter_at_position(
		affiliation, unit_type, unit_size, callsign, pos_m
	)

	_spotted_contacts[contact_id] = true

	LogService.debug(
		"Spawned counter for contact %s at %s" % [callsign, pos_m], "UnitAutoResponses.gd"
	)
```
