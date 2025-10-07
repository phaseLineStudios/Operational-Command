# TerrainData::get_elevation_block Function Reference

*Defined at:* `scripts/data/TerrainData.gd` (lines 332–347)</br>
*Belongs to:* [TerrainData](../../TerrainData.md)

**Signature**

```gdscript
func get_elevation_block(rect: Rect2i) -> PackedFloat32Array
```

## Description

Returns a row-major block of elevation samples (r channel) for the clipped rect.

## Source

```gdscript
func get_elevation_block(rect: Rect2i) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	if elevation == null or elevation.is_empty():
		return out
	var r := _clip_rect_to_image(rect, elevation)
	if r.size.x <= 0 or r.size.y <= 0:
		return out
	out.resize(r.size.x * r.size.y)
	var k := 0
	for y in r.size.y:
		for x in r.size.x:
			out[k] = elevation.get_pixel(r.position.x + x, r.position.y + y).r
			k += 1
	return out
```
