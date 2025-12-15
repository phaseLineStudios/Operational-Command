# UnitAutoResponses::trigger_fuel_critical Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 614–617)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func trigger_fuel_critical(unit_id: String) -> void
```

- **unit_id**: Unit experiencing critical fuel.

## Description

Trigger fuel critical event for unit.

## Source

```gdscript
func trigger_fuel_critical(unit_id: String) -> void:
	_queue_message(unit_id, EventType.FUEL_CRITICAL)
```
