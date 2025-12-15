# UnitAutoResponses::trigger_ammo_critical Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 602–605)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func trigger_ammo_critical(unit_id: String) -> void
```

- **unit_id**: Unit experiencing critical ammo.

## Description

Trigger ammo critical event for unit.

## Source

```gdscript
func trigger_ammo_critical(unit_id: String) -> void:
	_queue_message(unit_id, EventType.AMMO_CRITICAL)
```
