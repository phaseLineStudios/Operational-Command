# MoraleSystem::nearby_ally_morale_change Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 84–101)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func nearby_ally_morale_change(amount: float = 0.0, source: String = "nearby victory") -> void
```

## Description

applies morale boost to nearby units

## Source

```gdscript
func nearby_ally_morale_change(amount: float = 0.0, source: String = "nearby victory") -> void:
	var nearby: Array = []
	var max_distance = 500

	for other in scenario.units:
		if other == owner:
			continue
		if other.affiliation != owner.affiliation:
			continue

		var dist = other.position_m.distance_to(owner.position_m)
		if dist <= max_distance:
			nearby.append(other)

	for ally in nearby:
		ally.morale_system.apply_morale_delta(amount, source)
```
