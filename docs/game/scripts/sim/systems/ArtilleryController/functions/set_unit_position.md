# ArtilleryController::set_unit_position Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 126–129)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

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
