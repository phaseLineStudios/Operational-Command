# TerrainData::get_elev_px Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 373–382)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func get_elev_px(px: Vector2i) -> float
```

## Description

Get elevation (meters) at sample coord.

## Source

```gdscript
func get_elev_px(px: Vector2i) -> float:
	if elevation.is_empty():
		return 0.0
	var w := elevation.get_width()
	var h := elevation.get_height()
	var x: int = clamp(px.x, 0, w - 1)
	var y: int = clamp(px.y, 0, h - 1)
	return elevation.get_pixel(x, y).r
```
