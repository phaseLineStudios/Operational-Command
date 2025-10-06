# TerrainData::set_elev_px Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 384–392)</br>
*Belongs to:* [TerrainData](../TerrainData.md)

**Signature**

```gdscript
func set_elev_px(px: Vector2i, meters: float) -> void
```

## Description

Set elevation (meters) at sample coord.

## Source

```gdscript
func set_elev_px(px: Vector2i, meters: float) -> void:
	if elevation.is_empty():
		return
	if px.x < 0 or px.y < 0 or px.x >= elevation.get_width() or px.y >= elevation.get_height():
		return
	elevation.set_pixel(px.x, px.y, Color(meters, 0, 0))
	emit_signal("elevation_changed", Rect2i(px, Vector2i(1, 1)))
```
