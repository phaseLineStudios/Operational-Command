# UnitAutoResponses::_report_unit_death Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 757–798)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _report_unit_death(dead_unit_id: String) -> void
```

- **dead_unit_id**: ID of the unit that just died.

## Description

Report unit death via an observer with LOS.
If no friendly unit has LOS, nothing is reported (silence).

## Source

```gdscript
func _report_unit_death(dead_unit_id: String) -> void:
	var dead_unit: ScenarioUnit = _units_by_id.get(dead_unit_id)
	if not dead_unit:
		return

	var dead_callsign: String = _id_to_callsign.get(dead_unit_id, dead_unit_id)
	var is_friendly_death := dead_unit.affiliation == ScenarioUnit.Affiliation.FRIEND

	var observers: Array = []
	for other_id in _units_by_id.keys():
		var other: ScenarioUnit = _units_by_id.get(other_id)
		if not other or other == dead_unit:
			continue
		if not other.playable or other.affiliation != ScenarioUnit.Affiliation.FRIEND:
			continue
		if other.is_dead():
			continue
		if _has_los_between(other, dead_unit):
			observers.append(other)

	if observers.is_empty():
		return

	var closest: ScenarioUnit = observers[0]
	var closest_dist := closest.position_m.distance_to(dead_unit.position_m)
	for obs in observers:
		var dist: float = obs.position_m.distance_to(dead_unit.position_m)
		if dist < closest_dist:
			closest = obs
			closest_dist = dist

	var observer_callsign: String = _id_to_callsign.get(closest.id, closest.id)
	var message: String

	if is_friendly_death:
		message = "%s is down." % dead_callsign
	else:
		message = "%s is destroyed." % dead_callsign

	_queue_custom_message(closest.id, observer_callsign, message, Priority.HIGH)
```
