# AmmoSystem::_needs_ammo Function Reference

*Defined at:* `scripts/sim/systems/AmmoSystem.gd` (lines 181–193)</br>
*Belongs to:* [AmmoSystem](../../AmmoSystem.md)

**Signature**

```gdscript
func _needs_ammo(su: ScenarioUnit) -> bool
```

## Description

True if any ammo type is below its cap, unit is alive, and is stationary.

## Source

```gdscript
func _needs_ammo(su: ScenarioUnit) -> bool:
	# Don't resupply dead units
	if su.state_strength <= 0:
		return false
	# Only resupply stationary units
	if su.move_state() != ScenarioUnit.MoveState.IDLE:
		return false
	for t in su.unit.ammunition.keys():
		if int(su.state_ammunition.get(t, 0)) < int(su.unit.ammunition[t]):
			return true
	return false
```
