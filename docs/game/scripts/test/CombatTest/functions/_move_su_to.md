# CombatTest::_move_su_to Function Reference

*Defined at:* `scripts/test/CombatTest.gd` (lines 101–108)</br>
*Belongs to:* [CombatTest](../../CombatTest.md)

**Signature**

```gdscript
func _move_su_to(su: ScenarioUnit, dest_m: Vector2) -> void
```

## Source

```gdscript
func _move_su_to(su: ScenarioUnit, dest_m: Vector2) -> void:
	if su == null or renderer.path_grid == null:
		return
	if su.plan_move(renderer.path_grid, dest_m):
		su.start_move(renderer.path_grid)
		print("%s -> %s (%s)" % [su.callsign, str(dest_m), renderer.pos_to_grid(dest_m)])
```
