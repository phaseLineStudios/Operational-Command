# MoraleSystem::safe_rest Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 121–140)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func safe_rest() -> void
```

## Description

gains morale if no enemies nearby

## Source

```gdscript
func safe_rest() -> void:
	if not scenario or not scenario.units:
		return

	var min_distance = 2000
	var safe = true

	for other in scenario.units:
		if other == owner:
			continue
		if other.affiliation == owner.affiliation:
			continue
		var dist = other.position_m.distance_to(owner.position_m)
		if dist <= min_distance:
			safe = false
	if safe == true && owner.move_state() == ScenarioUnit.MoveState.IDLE:
		if morale + 0.3 > 0.6:
			set_morale(0.6, "safe rest")
		else:
			apply_morale_delta(0.3, "safe rest")
```
