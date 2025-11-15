# TerrainEffects::_get_h Function Reference

*Defined at:* `scripts/sim/TerrainEffects.gd` (lines 230–236)</br>
*Belongs to:* [TerrainEffects](../../TerrainEffects.md)

**Signature**

```gdscript
func _get_h(terrain: TerrainData, p: Vector2) -> float
```

## Source

```gdscript
static func _get_h(terrain: TerrainData, p: Vector2) -> float:
	if terrain == null:
		return 0.0
	var px := terrain.world_to_elev_px(p)
	return float(terrain.get_elev_px(px)) + float(terrain.base_elevation_m)
```
