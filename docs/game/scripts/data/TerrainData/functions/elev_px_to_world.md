# TerrainData::elev_px_to_world Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 419–422)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func elev_px_to_world(px: Vector2i) -> Vector2
```

## Description

Convert elevation pixel coords to world meters (top-left origin).

## Source

```gdscript
func elev_px_to_world(px: Vector2i) -> Vector2:
	return Vector2(px.x * elevation_resolution_m, px.y * elevation_resolution_m)
```
