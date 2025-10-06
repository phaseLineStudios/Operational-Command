# ContourLayer::_march_level_segments Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 260–332)</br>
*Belongs to:* [ContourLayer](../ContourLayer.md)

**Signature**

```gdscript
func _march_level_segments(img: Image, w: int, h: int, step_m: float, level: float) -> Array
```

## Description

March over segments for a level

## Source

```gdscript
func _march_level_segments(img: Image, w: int, h: int, step_m: float, level: float) -> Array:
	var segs: Array = []

	for j in range(0, h - 1):
		for i in range(0, w - 1):
			var ztl := img.get_pixel(i, j).r
			var ztr := img.get_pixel(i + 1, j).r
			var zbr := img.get_pixel(i + 1, j + 1).r
			var zbl := img.get_pixel(i, j + 1).r

			var x0 := i * step_m
			var y0 := j * step_m
			var x1 := (i + 1) * step_m
			var y1 := (j + 1) * step_m

			var c := 0
			if ztl > level:
				c |= 1
			if ztr > level:
				c |= 2
			if zbr > level:
				c |= 4
			if zbl > level:
				c |= 8
			if c == 0 or c == 15:
				continue

			var lerp_t = func(a: float, b: float) -> float:
				var denom := b - a
				return 0.5 if abs(denom) < 1e-6 else clamp((level - a) / denom, 0.0, 1.0)

			var pts := {}

			if (c & 1) != (c & 2):
				var t0: float = lerp_t.call(ztl, ztr)
				pts[0] = Vector2(lerp(x0, x1, t0), y0)
			if (c & 2) != (c & 4):
				var t1: float = lerp_t.call(ztr, zbr)
				pts[1] = Vector2(x1, lerp(y0, y1, t1))
			if (c & 4) != (c & 8):
				var t2: float = lerp_t.call(zbr, zbl)
				pts[2] = Vector2(lerp(x1, x0, t2), y1)
			if (c & 8) != (c & 1):
				var t3: float = lerp_t.call(zbl, ztl)
				pts[3] = Vector2(x0, lerp(y1, y0, t3))

			match c:
				1, 14:
					segs.append(PackedVector2Array([pts[3], pts[0]]))
				2, 13:
					segs.append(PackedVector2Array([pts[0], pts[1]]))
				4, 11:
					segs.append(PackedVector2Array([pts[1], pts[2]]))
				8, 7:
					segs.append(PackedVector2Array([pts[2], pts[3]]))
				3, 12:
					segs.append(PackedVector2Array([pts[3], pts[1]]))
				6, 9:
					segs.append(PackedVector2Array([pts[0], pts[2]]))
				5, 10:
					var zc := (ztl + ztr + zbr + zbl) * 0.25
					if zc > level:
						segs.append(PackedVector2Array([pts[0], pts[1]]))
						segs.append(PackedVector2Array([pts[2], pts[3]]))
					else:
						segs.append(PackedVector2Array([pts[3], pts[0]]))
						segs.append(PackedVector2Array([pts[1], pts[2]]))
				_:
					pass

	return segs
```
