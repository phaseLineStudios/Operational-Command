# ScenarioTasksService::_init_defs Function Reference

*Defined at:* `scripts/editors/services/ScenarioTasksService.gd` (lines 14–23)</br>
*Belongs to:* [ScenarioTasksService](../../ScenarioTasksService.md)

**Signature**

```gdscript
func _init_defs() -> void
```

## Source

```gdscript
func _init_defs() -> void:
	defs.clear()
	defs.append(UnitTaskMove.new())
	defs.append(UnitTaskDefend.new())
	defs.append(UnitTaskWait.new())
	defs.append(UnitTaskPatrol.new())
	defs.append(UnitTaskSetBehaviour.new())
	defs.append(UnitTaskSetCombatMode.new())
```
