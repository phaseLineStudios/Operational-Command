# MovementAdapter::tick_units Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 181–200)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func tick_units(units: Array[ScenarioUnit], dt: float) -> void
```

- **units**: Units to tick.
- **dt**: Delta time in seconds.

## Description

Ticks unit movement grouped by profile (reduces grid switching).
Skips groups whose profile grid is still building this frame.

## Source

```gdscript
func tick_units(units: Array[ScenarioUnit], dt: float) -> void:
	if _grid == null or units.is_empty():
		return

	_prebuild_needed_profiles(units)

	var groups := {}
	for u in units:
		var p := u.unit.movement_profile
		if not groups.has(p):
			groups[p] = []
		groups[p].append(u)

	for p in groups.keys():
		if _grid.ensure_profile(p):
			_grid.use_profile(p)
			for u in groups[p]:
				u.tick(dt, _grid)
```
