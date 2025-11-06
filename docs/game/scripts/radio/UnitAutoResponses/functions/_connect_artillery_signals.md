# UnitAutoResponses::_connect_artillery_signals Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 329–346)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _connect_artillery_signals() -> void
```

## Description

Connect to artillery controller signals.

## Source

```gdscript
func _connect_artillery_signals() -> void:
	if not _artillery_controller:
		return

	if not _artillery_controller.mission_confirmed.is_connected(_on_mission_confirmed):
		_artillery_controller.mission_confirmed.connect(_on_mission_confirmed)
	if not _artillery_controller.rounds_shot.is_connected(_on_rounds_shot):
		_artillery_controller.rounds_shot.connect(_on_rounds_shot)
	if not _artillery_controller.rounds_splash.is_connected(_on_rounds_splash):
		_artillery_controller.rounds_splash.connect(_on_rounds_splash)
	if not _artillery_controller.rounds_impact.is_connected(_on_rounds_impact):
		_artillery_controller.rounds_impact.connect(_on_rounds_impact)
	if not _artillery_controller.battle_damage_assessment.is_connected(
		_on_battle_damage_assessment
	):
		_artillery_controller.battle_damage_assessment.connect(_on_battle_damage_assessment)
```
