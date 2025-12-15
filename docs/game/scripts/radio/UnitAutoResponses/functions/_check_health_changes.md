# UnitAutoResponses::_check_health_changes Function Reference

*Defined at:* `scripts/radio/UnitAutoResponses.gd` (lines 486–522)</br>
*Belongs to:* [UnitAutoResponses](../../UnitAutoResponses.md)

**Signature**

```gdscript
func _check_health_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void
```

## Description

Check for health/casualty changes.

## Source

```gdscript
func _check_health_changes(unit_id: String, prev: Dictionary, current: Dictionary) -> void:
	var unit: ScenarioUnit = _units_by_id.get(unit_id)
	if not unit or not unit.unit:
		return

	var prev_strength: int = prev.get("strength", unit.unit.strength)
	var curr_strength: int = int(unit.state_strength)
	var max_strength: int = unit.unit.strength

	current["strength"] = curr_strength

	var was_alive := prev_strength > 0
	var is_dead := unit.is_dead()
	if was_alive and is_dead:
		_report_unit_death(unit_id)
		return

	if is_dead:
		return

	if curr_strength >= prev_strength:
		return

	var casualties := prev_strength - curr_strength
	var strength_pct := (float(curr_strength) / float(max_strength)) * 100.0

	var prev_strength_pct := (float(prev_strength) / float(max_strength)) * 100.0
	if prev_strength_pct >= 25.0 and strength_pct < 25.0:
		_queue_message(unit_id, EventType.COMBAT_INEFFECTIVE)

	var casualty_pct := (float(casualties) / float(max_strength)) * 100.0
	if casualty_pct >= 25.0:
		_trigger_command_change(unit_id)
	else:
		_trigger_casualties(unit_id, casualties, curr_strength)
```
