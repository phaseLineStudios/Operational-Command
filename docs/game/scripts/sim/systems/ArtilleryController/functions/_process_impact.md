# ArtilleryController::_process_impact Function Reference

*Defined at:* `scripts/sim/systems/ArtilleryController.gd` (lines 347–354)</br>
*Belongs to:* [ArtilleryController](../../ArtilleryController.md)

**Signature**

```gdscript
func _process_impact(mission: FireMission) -> void
```

## Description

Process mission completion and generate BDA

## Source

```gdscript
func _process_impact(mission: FireMission) -> void:
	# Note: Individual round impact signals are emitted in tick()
	# This function handles mission completion and BDA only

	# Generate BDA from nearby friendly observers
	_generate_bda(mission)
```
