# TerrainEffects::_extract_pos Function Reference

*Defined at:* `scripts/sim/TerrainEffects.gd` (lines 237–248)</br>
*Belongs to:* [TerrainEffects](../../TerrainEffects.md)

**Signature**

```gdscript
func _extract_pos(x: ScenarioUnit, fallback: Vector2) -> Vector2
```

## Source

```gdscript
static func _extract_pos(x: ScenarioUnit, fallback: Vector2) -> Vector2:
	if x == null:
		return fallback
	if "position_m" in x:
		return x.position_m
	if "world_pos" in x:
		return x.world_pos
	if x.has_method("get_world_pos"):
		return x.get_world_pos()
	return fallback
```
