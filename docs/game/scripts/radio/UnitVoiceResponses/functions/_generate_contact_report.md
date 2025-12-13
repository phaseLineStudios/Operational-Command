# UnitVoiceResponses::_generate_contact_report Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 271–323)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _generate_contact_report(unit: ScenarioUnit, callsign: String) -> String
```

- **unit**: ScenarioUnit to report on.
- **callsign**: Unit callsign.
- **Return Value**: Contact report string.

## Description

Generate contact report: known hostile elements and their status/positions.

## Source

```gdscript
func _generate_contact_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	parts.append(callsign)

	if sim_world == null or not sim_world.has_method("get_contacts_for_unit"):
		parts.append("no contact data available")
		return ". ".join(parts) + "."

	var contacts: Array = sim_world.get_contacts_for_unit(unit.id)

	if contacts.is_empty():
		parts.append("no hostile contacts")
		return ". ".join(parts) + "."

	parts.append("%d hostile contact%s" % [contacts.size(), "s" if contacts.size() > 1 else ""])

	var max_contacts := mini(contacts.size(), 3)
	for i in max_contacts:
		var contact: ScenarioUnit = contacts[i]
		if contact == null:
			continue

		var contact_parts: Array[String] = []

		if not contact.callsign.is_empty():
			contact_parts.append(contact.callsign)
		elif contact.unit and not contact.unit.title.is_empty():
			contact_parts.append(contact.unit.title)
		else:
			contact_parts.append("hostile unit")

		var grid_pos := _get_grid_position(contact.position_m)
		if not grid_pos.is_empty():
			contact_parts.append("grid %s" % grid_pos)

		if not contact_parts.is_empty():
			parts.append(". ".join(contact_parts))

	if contacts.size() > max_contacts:
		parts.append(
			(
				"plus %d additional contact%s"
				% [
					contacts.size() - max_contacts,
					"s" if contacts.size() - max_contacts > 1 else ""
				]
			)
		)

	return ". ".join(parts) + "."
```
