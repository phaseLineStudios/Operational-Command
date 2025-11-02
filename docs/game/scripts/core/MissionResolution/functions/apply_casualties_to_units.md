# MissionResolution::apply_casualties_to_units Function Reference

*Defined at:* `scripts/core/MissionResolution.gd` (lines 195–211)</br>
*Belongs to:* [MissionResolution](../../MissionResolution.md)

**Signature**

```gdscript
func apply_casualties_to_units(units: Array, losses: Dictionary) -> void
```

## Description

Apply per-unit casualties to UnitData.state_strength.
`losses` is { unit_id: lost_personnel }.
This mutates the UnitData instances passed in.

## Source

```gdscript
func apply_casualties_to_units(units: Array, losses: Dictionary) -> void:
	var map: Dictionary = {}
	for u in units:
		if u is UnitData:
			map[u.id] = u
		elif u is ScenarioUnit and u.unit:
			map[u.unit.id] = u.unit
	for uid in losses.keys():
		var loss := int(losses[uid])
		var target: UnitData = map.get(uid, null)
		if target == null:
			continue
		var before := int(round(target.state_strength))
		var after: float = max(0, before - max(0, loss))
		target.state_strength = float(after)
```
