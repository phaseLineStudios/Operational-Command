# AIController::refresh_unit_index_cache Function Reference

*Defined at:* `scripts/ai/AIController.gd` (lines 449–462)</br>
*Belongs to:* [AIController](../../AIController.md)

**Signature**

```gdscript
func refresh_unit_index_cache() -> void
```

## Description

Rebuild the ScenarioUnit id -> index cache for quick lookups.

## Source

```gdscript
func refresh_unit_index_cache() -> void:
	_unit_index_cache.clear()
	if Game.current_scenario == null:
		return
	var units: Array = Game.current_scenario.units
	for i in units.size():
		var su: ScenarioUnit = units[i]
		if su == null:
			continue
		if su.id == null or String(su.id).is_empty():
			continue
		_unit_index_cache[String(su.id)] = i
```
