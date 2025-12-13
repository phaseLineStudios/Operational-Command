# UnitVoiceResponses::_generate_status_report Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 207–236)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _generate_status_report(unit: ScenarioUnit, callsign: String) -> String
```

- **unit**: ScenarioUnit to report on.
- **callsign**: Unit callsign.
- **Return Value**: Status report string.

## Description

Generate status report: unit status, position, and current task.

## Source

```gdscript
func _generate_status_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	parts.append(callsign)

	var strength_pct := 0.0
	if unit.unit and unit.unit.strength > 0:
		strength_pct = (float(unit.state_strength) / float(unit.unit.strength)) * 100.0
	var status := "nominal"
	if strength_pct <= 0:
		status = "destroyed"
	elif strength_pct < 25:
		status = "critical"
	elif strength_pct < 50:
		status = "damaged"
	elif strength_pct < 75:
		status = "light damage"
	parts.append("status %s" % status)

	var grid_pos := _get_grid_position(unit.position_m)
	if not grid_pos.is_empty():
		parts.append("position grid %s" % grid_pos)

	var task := _get_current_task(unit)
	if not task.is_empty():
		parts.append(task)

	return ". ".join(parts) + "."
```
