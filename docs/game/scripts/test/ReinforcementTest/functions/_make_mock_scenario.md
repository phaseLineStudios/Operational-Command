# ReinforcementTest::_make_mock_scenario Function Reference

*Defined at:* `scripts/test/ReinforcementTest.gd` (lines 189–202)</br>
*Belongs to:* [ReinforcementTest](../../ReinforcementTest.md)

**Signature**

```gdscript
func _make_mock_scenario() -> Node
```

## Description

Build a mock scenario compatible with SimWorld.spawn_scenario_units()

## Source

```gdscript
func _make_mock_scenario() -> Node:
	var sc_script: GDScript = GDScript.new()
	sc_script.source_code = "extends Node\nvar units: Array = []\n"
	sc_script.reload()
	var scn: Node = Node.new()
	scn.set_script(sc_script)
	var list: Array = []
	for u: UnitData in _units:
		var su: Object = _make_mock_scenario_unit(u)
		list.append(su)
	scn.units = list
	return scn
```
