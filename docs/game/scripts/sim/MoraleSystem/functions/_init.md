# MoraleSystem::_init Function Reference

*Defined at:* `scripts/sim/MoraleSystem.gd` (lines 20–26)</br>
*Belongs to:* [MoraleSystem](../../MoraleSystem.md)

**Signature**

```gdscript
func _init(u_id: String = "", u_owner: ScenarioUnit = null) -> void
```

## Description

sets value of id variables

## Source

```gdscript
func _init(u_id: String = "", u_owner: ScenarioUnit = null) -> void:
	unit_id = u_id
	morale_state = get_morale_state(morale)
	owner = u_owner
	scenario = Game.current_scenario
```
