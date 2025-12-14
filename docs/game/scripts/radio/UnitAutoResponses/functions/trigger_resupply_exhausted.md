# UnitAutoResponses::trigger_resupply_exhausted Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 588–591)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func trigger_resupply_exhausted(src_unit_id: String) -> void
```

- **src_unit_id**: Supplier unit ID that ran out.

## Description

Trigger resupply exhausted event (supplier ran out).

## Source

```gdscript
func trigger_resupply_exhausted(src_unit_id: String) -> void:
	_queue_message(src_unit_id, EventType.RESUPPLY_EXHAUSTED)
```
