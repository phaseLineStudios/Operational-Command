# UnitAutoResponses::_report_contact_lost Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 741–753)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _report_contact_lost(spotter_id: String, contact_id: String) -> void
```

- **spotter_id**: Unit that lost contact.
- **contact_id**: Enemy unit that is no longer visible.

## Description

Report when contact is lost (enemy retreated, moved out of LOS, etc.).

## Source

```gdscript
func _report_contact_lost(spotter_id: String, contact_id: String) -> void:
	var contact_unit = _units_by_id.get(contact_id)
	if not contact_unit or not contact_unit.is_dead():
		_queue_message(spotter_id, EventType.CONTACT_LOST)
	if _active_contacts.has(spotter_id) and contact_id in _active_contacts[spotter_id]:
		_active_contacts[spotter_id].erase(contact_id)

	var engagement_key1 := "%s|%s" % [spotter_id, contact_id]
	var engagement_key2 := "%s|%s" % [contact_id, spotter_id]
	_active_engagements.erase(engagement_key1)
	_active_engagements.erase(engagement_key2)
```
