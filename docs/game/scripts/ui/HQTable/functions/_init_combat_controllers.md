# HQTable::_init_combat_controllers Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 179–192)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _init_combat_controllers() -> void
```

## Description

Bind artillery and engineer controllers to trigger API for tracking

## Source

```gdscript
func _init_combat_controllers() -> void:
	if trigger_engine and trigger_engine._api and sim:
		if sim.artillery_controller:
			trigger_engine._api._bind_artillery_controller(sim.artillery_controller)

		if sim.engineer_controller:
			trigger_engine._api._bind_engineer_controller(sim.engineer_controller)

	if combat_sound and sim:
		combat_sound.bind_sim_world(sim)
		if sim.artillery_controller:
			combat_sound.bind_artillery_controller(sim.artillery_controller)
```
