# MovementAdapter::_on_grid_ready Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 320–351)</br>
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
			var is_direct: bool = su.get_meta("_pending_start_direct", false)
			su.remove_meta("_pending_start_profile")
			su.remove_meta("_pending_start_dest")
			su.remove_meta("_pending_start_direct")

			# Use direct or normal pathfinding
			var planned: bool = false
			if is_direct:
				planned = su.plan_direct_move(_grid, dest_m)
			else:
				planned = su.plan_move(_grid, dest_m)

			if planned:
				su.start_move(_grid)
```
