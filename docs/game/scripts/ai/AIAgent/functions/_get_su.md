# AIAgent::_get_su Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 77–85)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func _get_su() -> ScenarioUnit
```

## Source

```gdscript
func _get_su() -> ScenarioUnit:
	if Game.current_scenario == null:
		return null
	var units: Array = Game.current_scenario.units
	if unit_id >= 0 and unit_id < units.size():
		return units[unit_id]
	return null
```
