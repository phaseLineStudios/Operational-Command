# MovementAdapter::_on_grid_ready Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 233–252)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _on_grid_ready(profile: int) -> void
```

- **profile**: Movement profile that became available.

## Description

Starts any deferred moves whose profile just finished building.

## Source

```gdscript
func _on_grid_ready(profile: int) -> void:
	var scen := Game.current_scenario
	if scen == null:
		return
	var all_units: Array = []
	all_units.append_array(scen.units)
	all_units.append_array(scen.playable_units)
	_grid.use_profile(profile)
	for su in all_units:
		if su == null:
			continue
		if (
			su.has_meta("_pending_start_profile")
			and int(su.get_meta("_pending_start_profile")) == profile
		):
			var dest_m: Vector2 = su.get_meta("_pending_start_dest")
			su.erase_meta("_pending_start_profile")
			su.erase_meta("_pending_start_dest")
			if su.plan_move(_grid, dest_m):
				su.start_move(_grid)
```
