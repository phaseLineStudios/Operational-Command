# MovementAdapter::set_patrol_dwell Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 432–435)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func set_patrol_dwell(seconds: float) -> void
```

## Description

Optional setter to customize dwell time between patrol legs

## Source

```gdscript
func set_patrol_dwell(seconds: float) -> void:
	patrol_dwell_seconds = max(0.0, seconds)
```
