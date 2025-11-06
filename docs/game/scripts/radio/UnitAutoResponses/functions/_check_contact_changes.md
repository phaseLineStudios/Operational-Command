# UnitAutoResponses::_check_contact_changes Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 465–475)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _check_contact_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void
```

## Description

Check for contact changes (enemies spotted/lost).

## Source

```gdscript
func _check_contact_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var prev_contacts: Array = prev.get("contacts", [])
	var curr_contacts: Array = current.get("contacts", [])

	if curr_contacts.size() > prev_contacts.size():
		_queue_message(unit_id, EventType.CONTACT_SPOTTED)

	elif curr_contacts.size() < prev_contacts.size() and curr_contacts.is_empty():
		_queue_message(unit_id, EventType.CONTACT_LOST)
```
