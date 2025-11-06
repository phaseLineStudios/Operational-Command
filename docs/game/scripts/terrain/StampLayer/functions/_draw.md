# StampLayer::_draw Function Reference

*Defined at:* `scripts/terrain/StampLayer.gd` (lines 40–53)</br>
*Belongs to:* [StampLayer](../../StampLayer.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
func _draw() -> void:
	if _stamps.is_empty():
		return

	# Get TerrainRender parent for coordinate conversion
	var terrain_render := _get_terrain_render()
	if not terrain_render:
		LogService.warning("StampLayer: Cannot find TerrainRender parent", "StampLayer.gd")
		return

	for stamp in _stamps:
		_draw_stamp(stamp, terrain_render)
```
