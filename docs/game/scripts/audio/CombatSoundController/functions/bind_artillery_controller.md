# CombatSoundController::bind_artillery_controller Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 106–115)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func bind_artillery_controller(artillery: ArtilleryController) -> void
```

## Description

Wire up to artillery controller signals.

## Source

```gdscript
func bind_artillery_controller(artillery: ArtilleryController) -> void:
	if not artillery:
		return

	artillery.rounds_shot.connect(_on_artillery_shot)
	artillery.rounds_impact.connect(_on_artillery_impact)

	LogService.debug("CombatSoundController bound to ArtilleryController", "CombatSoundController")
```
