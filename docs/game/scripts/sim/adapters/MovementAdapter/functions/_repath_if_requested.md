# MovementAdapter::_repath_if_requested Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 603–614)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _repath_if_requested(su: ScenarioUnit) -> void
```

## Source

```gdscript
func _repath_if_requested(su: ScenarioUnit) -> void:
	if su == null:
		return
	if not su.has_meta("env_repath_requested"):
		return
	su.remove_meta("env_repath_requested")
	var dest: Vector2 = su.destination_m()
	if not dest.is_finite():
		return
	plan_and_start(su, dest)
```
