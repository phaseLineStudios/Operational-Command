# TerrainElevationTool::_block_from_image Function Reference

*Defined at:* `scripts/editors/tools/TerrainElevationTool.gd` (lines 250–262)</br>
*Belongs to:* [TerrainElevationTool](../../TerrainElevationTool.md)

**Signature**

```gdscript
func _block_from_image(img: Image, rect: Rect2i) -> PackedFloat32Array
```

## Description

Returns a row-major block of elevation samples for the clipped rect.

## Source

```gdscript
func _block_from_image(img: Image, rect: Rect2i) -> PackedFloat32Array:
	var out := PackedFloat32Array()
	if img == null or img.is_empty() or rect.size.x <= 0 or rect.size.y <= 0:
		return out
	out.resize(rect.size.x * rect.size.y)
	var k := 0
	for y in rect.size.y:
		for x in rect.size.x:
			out[k] = img.get_pixel(rect.position.x + x, rect.position.y + y).r
			k += 1
	return out
```
