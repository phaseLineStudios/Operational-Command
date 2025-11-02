# ReinforcementTest::_make_mock_scenario_unit Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 204–213)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _make_mock_scenario_unit(u: UnitData) -> Object
```

## Description

Make a mock "ScenarioUnit" object (extends Object) with .unit and .packed_scene

## Source

```gdscript
func _make_mock_scenario_unit(u: UnitData) -> Object:
	var sc: GDScript = GDScript.new()
	sc.source_code = "extends Object\nvar unit\nvar packed_scene\n"
	sc.reload()
	var inst: Object = sc.new()
	inst.unit = u
	inst.packed_scene = _make_unit_prefab()
	return inst
```
