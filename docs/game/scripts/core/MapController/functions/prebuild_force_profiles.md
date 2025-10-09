# MapController::prebuild_force_profiles Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 68–85)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func prebuild_force_profiles() -> void
```

## Description

Prebuild movement profiles

## Source

```gdscript
func prebuild_force_profiles() -> void:
	if renderer == null:
		return

	var scen := Game.current_scenario
	if scen == null:
		return

	var all_units: Array[ScenarioUnit] = []
	all_units.append_array(scen.units)
	all_units.append_array(scen.playable_units)
	var wanted := {}
	for su in all_units:
		wanted[su.unit.movement_profile] = true
	for p in wanted.keys():
		renderer.path_grid.rebuild(p)
```
