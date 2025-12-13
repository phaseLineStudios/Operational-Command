# ReinforcementTest::_test_casualties Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 256–293)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _test_casualties() -> void
```

## Description

Prove that apply_casualties_to_units mutates state_strength in place

## Source

```gdscript
func _test_casualties() -> void:
	print("-- Casualty Test --")
	# Use the real MissionResolution class (must have class_name MissionResolution)
	var res: MissionResolution = MissionResolution.new()

	# Sample losses: try to remove 3 from ALPHA, 2 from CHARLIE
	var losses: Dictionary = {
		"ALPHA": 3,
		"CHARLIE": 2,
		# BRAVO stays 0 unless reinforced first
	}
	# Create ScenarioUnits for casualty application
	var scenario_units: Array = []
	for u: UnitData in _units:
		var su := ScenarioUnit.new()
		su.unit = u
		su.id = u.id
		su.state_strength = _unit_strength.get(u.id, 0.0)
		scenario_units.append(su)

	res.apply_casualties_to_units(scenario_units, losses)

	# Copy state back
	for su in scenario_units:
		_unit_strength[su.unit.id] = su.state_strength

	for u: UnitData in _units:
		prints(
			"[after casualties]",
			u.id,
			int(round(_unit_strength.get(u.id, 0.0))),
			"/",
			int(u.strength)
		)
	_panel.set_units(_units, _unit_strength)
	_panel.set_pool(_pool)
```
