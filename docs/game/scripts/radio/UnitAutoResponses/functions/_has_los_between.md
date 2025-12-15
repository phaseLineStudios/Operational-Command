# UnitAutoResponses::_has_los_between Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 803–814)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _has_los_between(a: ScenarioUnit, b: ScenarioUnit) -> bool
```

- **a**: First unit.
- **b**: Second unit.
- **Return Value**: True if A can see B.

## Description

Check if unit A has LOS to unit B.

## Source

```gdscript
func _has_los_between(a: ScenarioUnit, b: ScenarioUnit) -> bool:
	if not _sim_world or not _sim_world.los_adapter:
		var dist := a.position_m.distance_to(b.position_m)
		return dist < 2000.0

	return _sim_world.los_adapter.has_los(a, b)

	# Start queue timer if not already running
	if _queue_timer and _queue_timer.is_stopped():
		_queue_timer.start()
```
