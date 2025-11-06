# UnitAutoResponses::_on_engagement_reported Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 484–488)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _on_engagement_reported(attacker_id: String, defender_id: String) -> void
```

## Description

Handle engagement reported signal.

## Source

```gdscript
func _on_engagement_reported(attacker_id: String, defender_id: String) -> void:
	_queue_message(attacker_id, EventType.ENGAGING_TARGET)
	_queue_message(defender_id, EventType.TAKING_FIRE)
```
