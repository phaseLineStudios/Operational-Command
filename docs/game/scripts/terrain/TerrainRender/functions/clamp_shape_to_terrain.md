# TerrainRender::clamp_shape_to_terrain Function Reference

*Defined at:* `scripts/terrain/TerrainRender.gd` (lines 389–396)</br>
*Belongs to:* [TerrainRender](../../TerrainRender.md)

**Signature**

```gdscript
func clamp_shape_to_terrain(pts: PackedVector2Array) -> PackedVector2Array
```

## Description

Clamp an entire polygon (without mutating the source array)

## Source

```gdscript
func clamp_shape_to_terrain(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	out.resize(pts.size())
	for i in pts.size():
		out[i] = clamp_point_to_terrain(pts[i])
	return out
```
