# UnitAutoResponses::trigger_ammo_low Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 522–525)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func trigger_ammo_low(unit_id: String) -> void
```

- **unit_id**: Unit experiencing low ammo.

## Description

Trigger ammo low event for unit.

## Source

```gdscript
func trigger_ammo_low(unit_id: String) -> void:
	_queue_message(unit_id, EventType.AMMO_LOW)
```
