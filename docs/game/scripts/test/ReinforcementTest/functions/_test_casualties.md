# ReinforcementTest::_test_casualties Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 253–270)</br>
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
	res.apply_casualties_to_units(_units, losses)
	for u: UnitData in _units:
		prints("[after casualties]", u.id, int(round(u.state_strength)), "/", int(u.strength))
	_panel.set_units(_units)
	_panel.set_pool(_pool)
```
