# ArtilleryController::_generate_bda Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 258–285)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _generate_bda(mission: FireMission) -> void
```

## Description

Generate battle damage assessment from observer units

## Source

```gdscript
func _generate_bda(mission: FireMission) -> void:
	# Find friendly units near the impact point that can observe
	# Uses distance-based checks (artillery impacts are highly visible)
	for unit_id in _units.keys():
		var u: UnitData = _units[unit_id]
		if not u:
			continue

		# Skip the firing unit
		if unit_id == mission.unit_id:
			continue

		var pos: Vector2 = _positions.get(unit_id, Vector2.INF)
		if pos == Vector2.INF:
			continue

		# Check if within spotting range (artillery impacts are visible at distance)
		var distance: float = pos.distance_to(mission.target_pos)
		if distance > u.spot_m:
			continue

		# Generate BDA from first observer in range
		var description := _generate_bda_description(mission)
		emit_signal("battle_damage_assessment", unit_id, mission.target_pos, description)
		# Only one BDA per mission
		break
```
