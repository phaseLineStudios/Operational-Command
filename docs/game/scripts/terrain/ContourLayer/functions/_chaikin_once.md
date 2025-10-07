# ContourLayer::_chaikin_once Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 469–503)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _chaikin_once(pl: PackedVector2Array, closed: bool, keep_ends: bool) -> PackedVector2Array
```

## Description

One iteration of Chaikin corner cutting.

## Source

```gdscript
func _chaikin_once(pl: PackedVector2Array, closed: bool, keep_ends: bool) -> PackedVector2Array:
	var n := pl.size()
	if n < 3:
		return pl.duplicate()

	var out := PackedVector2Array()

	if closed:
		for i in n:
			var p0 := pl[(i - 1 + n) % n]
			var p1 := pl[i]
			var p2 := pl[(i + 1) % n]
			var q := p0 * 0.75 + p1 * 0.25
			var r := p1 * 0.75 + p2 * 0.25
			out.append(q)
			out.append(r)
		# close loop
		if out[0].distance_to(out[out.size() - 1]) > 1e-5:
			out.append(out[0])
	else:
		if keep_ends:
			out.append(pl[0])
		for i in range(1, n - 1):
			var p0 := pl[i - 1]
			var p1 := pl[i]
			var p2 := pl[i + 1]
			var q := p0 * 0.75 + p1 * 0.25
			var r := p1 * 0.75 + p2 * 0.25
			out.append(q)
			out.append(r)
		if keep_ends:
			out.append(pl[n - 1])
	return out
```
