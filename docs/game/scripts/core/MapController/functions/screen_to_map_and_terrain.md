# MapController::screen_to_map_and_terrain Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 492–506)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func screen_to_map_and_terrain(screen_pos: Vector2) -> Variant
```

## Description

Helper: from screen pos to map pixels & terrain meters. Returns null if not on map

## Source

```gdscript
func screen_to_map_and_terrain(screen_pos: Vector2) -> Variant:
	var hit: Variant = _raycast_to_map_plane(screen_pos)
	if hit == null:
		return null
	var map_px: Variant = _plane_hit_to_map_px(hit)
	if map_px == null or renderer == null:
		return null
	var s: float = (
		_viewport_pixel_scale if _viewport_pixel_scale > 0.0 else float(max(viewport_oversample, 1))
	)
	var logical_px: Vector2 = map_px / s
	var terrain_pos: Vector2 = renderer.map_to_terrain(logical_px)
	return {"map_px": map_px, "terrain": terrain_pos}
```
