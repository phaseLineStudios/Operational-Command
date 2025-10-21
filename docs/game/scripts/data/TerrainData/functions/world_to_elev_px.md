# TerrainData::world_to_elev_px Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 394–399)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func world_to_elev_px(p: Vector2) -> Vector2i
```

## Description

Convert world meters to elevation pixel coords.

## Source

```gdscript
func world_to_elev_px(p: Vector2) -> Vector2i:
	return Vector2i(
		int(round(p.x / elevation_resolution_m)), int(round(p.y / elevation_resolution_m))
	)
```
