# CombatSoundController::bind_sim_world Function Reference

*Defined at:* `scripts/audio/CombatSoundController.gd` (lines 117–125)</br>
*Belongs to:* [CombatSoundController](../../CombatSoundController.md)

**Signature**

```gdscript
func bind_sim_world(sim_world: SimWorld) -> void
```

## Description

Wire up to SimWorld signals.

## Source

```gdscript
func bind_sim_world(sim_world: SimWorld) -> void:
	if not sim_world:
		return

	sim_world.engagement_reported.connect(_on_engagement_reported)

	LogService.debug("CombatSoundController bound to SimWorld", "CombatSoundController")
```
