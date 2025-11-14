# MovementAdapter::request_move_to Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 357–363)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func request_move_to(dest: Vector3) -> void
```

## Description

TaskMove

## Source

```gdscript
func request_move_to(dest: Vector3) -> void:
	_patrol_running = false
	_holding = false
	_move_target = dest
	_moving = true
```
