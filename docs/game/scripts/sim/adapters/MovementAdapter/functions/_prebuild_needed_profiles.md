# MovementAdapter::_prebuild_needed_profiles Function Reference

*Defined at:* `scripts/sim/adapters/MovementAdapter.gd` (lines 165–176)</br>
*Belongs to:* [MovementAdapter](../../MovementAdapter.md)

**Signature**

```gdscript
func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void
```

## Description

Ensures PathGrid profiles needed by [param units] are available.
Triggers async builds for any missing profiles.

## Source

```gdscript
func _prebuild_needed_profiles(units: Array[ScenarioUnit]) -> void:
	if _grid == null:
		return
	var wanted := {}
	for u in units:
		var p := u.unit.movement_profile
		wanted[p] = true
	for p in wanted.keys():
		if not _grid.has_profile(p):
			_grid.ensure_profile(p)
```
