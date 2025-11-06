# ArtilleryController::_generate_bda_description Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 287–296)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _generate_bda_description(mission: FireMission) -> String
```

## Description

Generate BDA description based on mission type

## Source

```gdscript
func _generate_bda_description(mission: FireMission) -> String:
	if mission.ammo_type.ends_with("_AP"):
		return "Rounds on target, good effect."
	elif mission.ammo_type.ends_with("_SMOKE"):
		return "Smoke deployed, obscuring target area."
	elif mission.ammo_type.ends_with("_ILLUM"):
		return "Illumination rounds deployed, area lit."
	return "Rounds impacted."
```
