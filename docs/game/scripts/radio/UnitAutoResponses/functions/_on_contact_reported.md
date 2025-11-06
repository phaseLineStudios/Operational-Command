# UnitAutoResponses::_on_contact_reported Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 477–482)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _on_contact_reported(attacker_id: String, defender_id: String) -> void
```

## Description

Handle contact reported signal.

## Source

```gdscript
func _on_contact_reported(attacker_id: String, defender_id: String) -> void:
	_report_contact_spotted(attacker_id, defender_id)

	_spawn_contact_counter(defender_id)
```
