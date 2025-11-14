# CombatAdapter::_process Function Reference

*Defined at:* `scripts/sim/adapters/CombatAdapter.gd` (lines 34–40)</br>
*Belongs to:* [CombatAdapter](../../CombatAdapter.md)

**Signature**

```gdscript
func _process(dt: float) -> void
```

## Source

```gdscript
func _process(dt: float) -> void:
	if _saw_hostile_shot:
		_shot_timer -= dt
		if _shot_timer <= 0.0:
			_saw_hostile_shot = false
```
