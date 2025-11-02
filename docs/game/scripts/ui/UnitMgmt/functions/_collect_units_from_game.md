# UnitMgmt::_collect_units_from_game Function Reference

*Defined at:* `scripts/ui/UnitMgmt.gd` (lines 60–82)</br>
*Belongs to:* [UnitMgmt](../../UnitMgmt.md)

**Signature**

```gdscript
func _collect_units_from_game() -> Array[UnitData]
```

## Description

Return a flat array of UnitData from the current scenario or recruits.

## Source

```gdscript
func _collect_units_from_game() -> Array[UnitData]:
	var out: Array[UnitData] = []

	# Prefer the autoload (works whether you reference 'Game' or via tree)
	var g: Node = get_tree().get_root().get_node_or_null("/root/Game")
	if g and g.has_method("get_current_units"):
		var tmp: Array = g.call("get_current_units")
		for su in tmp:
			if su is ScenarioUnit and su.unit:
				out.append(su.unit)
			elif su is UnitData:
				out.append(su)
		return out

	# Fallback: read directly from Game.current_scenario if present
	if Game and Game.current_scenario:
		for su in Game.current_scenario.units:
			if su and su.unit:
				out.append(su.unit)

	return out
```
