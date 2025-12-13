# UnitAutoResponses::_on_unit_move_blocked Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 536–539)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _on_unit_move_blocked(reason: String, unit_id: String) -> void
```

- **reason**: Block reason code from ScenarioUnit.
- **unit_id**: Unit ID (bound parameter).

## Description

Handle unit move_blocked signal.

## Source

```gdscript
func _on_unit_move_blocked(reason: String, unit_id: String) -> void:
	trigger_movement_blocked(unit_id, reason)
```
