# FuelSystem::_on_move_paused Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 160–165)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _on_move_paused(uid: String) -> void
```

## Source

```gdscript
func _on_move_paused(uid: String) -> void:
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	if su != null:
		_pos[uid] = su.position_m
```
