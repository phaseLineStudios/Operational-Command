# UnitVoiceResponses::_handle_report Function Reference

*Defined at:* `scripts/radio/UnitVoiceResponses.gd` (lines 171–202)</br>
*Belongs to:* [UnitVoiceResponses](../../UnitVoiceResponses.md)

**Signature**

```gdscript
func _handle_report(order: Dictionary, callsign: String, unit_id: String) -> void
```

- **order**: Order dictionary with report_type field.
- **callsign**: Unit callsign.
- **unit_id**: Unit ID.

## Description

Handle report generation based on report type.

## Source

```gdscript
func _handle_report(order: Dictionary, callsign: String, unit_id: String) -> void:
	var unit: ScenarioUnit = units_by_id.get(unit_id)
	if unit == null:
		LogService.warning("Unit not found: %s" % unit_id, "UnitVoiceResponses.gd:_handle_report")
		return

	var report_type := str(order.get("report_type", "status"))

	var report := ""
	match report_type:
		"status":
			report = _generate_status_report(unit, callsign)
		"position":
			report = _generate_position_report(unit, callsign)
		"contact":
			report = _generate_contact_report(unit, callsign)
		"supply":
			report = _generate_supply_report(unit, callsign)
		_:
			report = _generate_status_report(unit, callsign)

	if not report.is_empty():
		_current_transmitter = callsign
		transmission_start.emit(callsign)

		TTSService.say(report)
		unit_response.emit(callsign, report)

	else:
		LogService.warning("Generated empty report", "UnitVoiceResponses.gd:_handle_report")
```
