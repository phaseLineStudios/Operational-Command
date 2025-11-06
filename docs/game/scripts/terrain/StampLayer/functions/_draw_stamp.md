# StampLayer::_draw_stamp Function Reference

*Defined at:* `scripts/terrain/StampLayer.gd` (lines 55–77)</br>
*Belongs to:* [StampLayer](../../StampLayer.md)

**Signature**

```gdscript
func _draw_stamp(stamp: ScenarioDrawingStamp, _terrain_render: TerrainRender) -> void
```

## Description

Draw a single stamp.

## Source

```gdscript
func _draw_stamp(stamp: ScenarioDrawingStamp, _terrain_render: TerrainRender) -> void:
	# Get texture
	var tex := _texture_cache.get(stamp.texture_path) as Texture2D
	if not tex:
		return

	# Calculate size in pixels
	var sz: Vector2 = tex.get_size() * stamp.scale

	# Calculate tint color with opacity
	var tint: Color = stamp.modulate
	tint.a *= stamp.opacity

	# Draw stamp centered at position with rotation
	draw_set_transform(stamp.position_m, deg_to_rad(stamp.rotation_deg))
	draw_texture_rect(tex, Rect2(-sz * 0.5, sz), false, tint)
	draw_set_transform(Vector2.ZERO, 0.0)

	# Draw label if present
	if stamp.label != null and stamp.label != "":
		_draw_stamp_label(stamp.label, stamp.position_m, sz.x * 0.5, tint)
```
