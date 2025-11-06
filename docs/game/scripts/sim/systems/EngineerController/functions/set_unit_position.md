# EngineerController::set_unit_position Function Reference

*Defined at:* `scripts/sim/systems/EngineerController.gd` (lines 65–68)</br>
*Belongs to:* [EngineerController](../../EngineerController.md)

**Signature**

```gdscript
func set_unit_position(unit_id: String, pos: Vector2) -> void
```

## Description

Update unit position

## Source

```gdscript
func set_unit_position(unit_id: String, pos: Vector2) -> void:
	_positions[unit_id] = pos
```
