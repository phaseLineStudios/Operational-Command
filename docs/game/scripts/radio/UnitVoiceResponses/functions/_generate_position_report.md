# UnitVoiceResponses::_generate_position_report Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 234–264)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _generate_position_report(unit: ScenarioUnit, callsign: String) -> String
```

- **unit**: ScenarioUnit to report on.
- **callsign**: Unit callsign.
- **Return Value**: Position report string.

## Description

Generate position report: position, direction if moving, speed if moving.

## Source

```gdscript
func _generate_position_report(unit: ScenarioUnit, callsign: String) -> String:
	var parts: Array[String] = []

	# Callsign
	parts.append(callsign)

	# Position (grid coordinate)
	var grid_pos := _get_grid_position(unit.position_m)
	if not grid_pos.is_empty():
		parts.append("position grid %s" % grid_pos)
	else:
		parts.append("position unknown")

	# Movement state
	var move_state := unit.move_state()
	if move_state == ScenarioUnit.MoveState.MOVING:
		# Get direction to destination
		var dest := unit.destination_m()
		if dest != Vector2.ZERO:
			var dir := _get_cardinal_direction(unit.position_m, dest)
			parts.append("moving %s" % dir)

			# Speed
			if unit.unit and unit.unit.speed_kph > 0:
				parts.append("speed %d kilometers per hour" % int(unit.unit.speed_kph))
	elif move_state == ScenarioUnit.MoveState.IDLE:
		parts.append("stationary")

	return ". ".join(parts) + "."
```
