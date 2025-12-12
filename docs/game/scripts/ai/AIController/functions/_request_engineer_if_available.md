# AIController::_request_engineer_if_available Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 581–598)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func _request_engineer_if_available(unit_index: int) -> void
```

## Description

Locate an engineer-capable unit and log a support request.

## Source

```gdscript
func _request_engineer_if_available(unit_index: int) -> void:
	if Game.current_scenario == null:
		return
	var su: ScenarioUnit = Game.current_scenario.units[unit_index]
	if su == null:
		return
	# Look for an engineer unit to assist; simply log the intent for now.
	for helper in Game.current_scenario.units:
		if helper == null or helper.is_dead():
			continue
		if helper.unit and helper.unit.is_engineer:
			LogService.info(
				"Engineer %s requested to assist %s" % [helper.id, su.id], "AIController.gd"
			)
			return
	LogService.info("Engineer support requested for %s (none available)" % su.id, "AIController.gd")
```
