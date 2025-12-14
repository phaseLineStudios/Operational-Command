# FuelSystem::_on_move_progress Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 137–140)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _on_move_progress(pos_m: Vector2, _eta: float, uid: String) -> void
```

## Description

Movement signal handlers

## Source

```gdscript
func _on_move_progress(pos_m: Vector2, _eta: float, uid: String) -> void:
	_pos[uid] = pos_m
```
