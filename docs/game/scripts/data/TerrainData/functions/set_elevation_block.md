# TerrainData::set_elevation_block Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 355–372)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func set_elevation_block(rect: Rect2i, block: PackedFloat32Array) -> void
```

## Description

Writes a row-major block of elevation samples (r channel) into the clipped rect.

## Source

```gdscript
func set_elevation_block(rect: Rect2i, block: PackedFloat32Array) -> void:
	if elevation == null or elevation.is_empty():
		return
	var r := _clip_rect_to_image(rect, elevation)
	if r.size.x <= 0 or r.size.y <= 0:
		return
	if block.size() != r.size.x * r.size.y:
		push_warning("set_elevation_block: size mismatch")
		return
	var k := 0
	for y in r.size.y:
		for x in r.size.x:
			var v := block[k]
			elevation.set_pixel(r.position.x + x, r.position.y + y, Color(v, 0.0, 0.0, 1.0))
			k += 1
	emit_signal("elevation_changed", r)
```
