# UnitAutoResponses::_get_current_contacts_for_unit Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 462–484)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _get_current_contacts_for_unit(unit_id: String) -> Array
```

## Description

Get list of enemy IDs currently in contact with this unit.
Filters out dead units to prevent stale contact tracking.

## Source

```gdscript
func _get_current_contacts_for_unit(unit_id: String) -> Array:
	if not _sim_world or not _sim_world.has_method("get_current_contacts"):
		return []

	var all_contacts: Array = _sim_world.get_current_contacts()
	var result: Array = []

	for pair in all_contacts:
		if typeof(pair) == TYPE_DICTIONARY:
			var contact_id: String = ""
			if pair.get("attacker") == unit_id:
				contact_id = pair.get("defender")
			elif pair.get("defender") == unit_id:
				contact_id = pair.get("attacker")

			if contact_id != "":
				var contact_unit: ScenarioUnit = _units_by_id.get(contact_id)
				if contact_unit and not contact_unit.is_dead():
					result.append(contact_id)

	return result
```
