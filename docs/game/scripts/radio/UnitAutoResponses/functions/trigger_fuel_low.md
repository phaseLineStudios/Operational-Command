# UnitAutoResponses::trigger_fuel_low Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 534–537)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func trigger_fuel_low(unit_id: String) -> void
```

- **unit_id**: Unit experiencing low fuel.

## Description

Trigger fuel low event for unit.

## Source

```gdscript
func trigger_fuel_low(unit_id: String) -> void:
	_queue_message(unit_id, EventType.FUEL_LOW)
```
