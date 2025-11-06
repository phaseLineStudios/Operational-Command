# ArtilleryController::_process_impact Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 235–256)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _process_impact(mission: FireMission) -> void
```

## Description

Process round impacts and generate damage/BDA

## Source

```gdscript
func _process_impact(mission: FireMission) -> void:
	var damage: float = 0.0

	# Calculate damage for AP rounds
	if mission.ammo_type.ends_with("_AP"):
		damage = ap_damage_per_round * mission.rounds
		# TODO: Apply damage to units in radius

	# Emit impact signal
	emit_signal(
		"rounds_impact",
		mission.unit_id,
		mission.target_pos,
		mission.ammo_type,
		mission.rounds,
		damage
	)

	# Generate BDA from nearby friendly observers
	_generate_bda(mission)
```
