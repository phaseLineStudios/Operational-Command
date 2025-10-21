# FuelSystem::_on_move_blocked Function Reference

*Defined at:* `scripts/sim/systems/FuelSystem.gd` (lines 152–157)</br>
*Belongs to:* [FuelSystem](../../FuelSystem.md)

**Signature**

```gdscript
func _on_move_blocked(_reason: String, uid: String) -> void
```

## Source

```gdscript
func _on_move_blocked(_reason: String, uid: String) -> void:
	var su: ScenarioUnit = _su.get(uid) as ScenarioUnit
	if su != null:
		_pos[uid] = su.position_m
```
