# TerrainEffects::_is_moving Function Reference

*Defined at:* `scripts/sim/TerrainEffects.gd` (lines 194–211)</br>
*Belongs to:* [TerrainEffects](../../TerrainEffects.md)

**Signature**

```gdscript
func _is_moving(x: ScenarioUnit) -> bool
```

## Source

```gdscript
static func _is_moving(x: ScenarioUnit) -> bool:
	if x == null:
		return false
	if "moving" in x:
		return bool(x.moving)
	if "is_moving" in x:
		return bool(x.is_moving)
	if x.has_method("is_moving"):
		return bool(x.is_moving())
	if x.has_method("move_state"):
		var st := x.move_state()
		if typeof(st) == TYPE_INT:
			return st == 2
	if "_move_state" in x and typeof(x._move_state) == TYPE_INT:
		return int(x._move_state) == 2
	return false
```
