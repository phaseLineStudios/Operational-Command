# ContourLayer::_layout_labels_on_line Function Reference

*Defined at:* `scripts/terrain/ContourLayer.gd` (lines 520–560)</br>
*Belongs to:* [ContourLayer](../../ContourLayer.md)

**Signature**

```gdscript
func _layout_labels_on_line(line: PackedVector2Array, spacing: float) -> Array
```

## Description

Compute cumulative length, place labels every `spacing` meters.

## Source

```gdscript
func _layout_labels_on_line(line: PackedVector2Array, spacing: float) -> Array:
	var out: Array = []
	var min_seg := 1e-6
	spacing = max(1.0, spacing)

	var l := PackedFloat32Array()
	l.resize(line.size())
	l[0] = 0.0
	for i in range(1, line.size()):
		l[i] = l[i - 1] + line[i - 1].distance_to(line[i])

	var total := l[l.size() - 1]
	if total < spacing:
		return out

	var next_s := spacing
	var i := 0
	while next_s <= total + 1e-5:
		while i < l.size() - 1 and l[i + 1] < next_s:
			i += 1
		if i >= l.size() - 1:
			break

		var seg_len: float = max(min_seg, line[i].distance_to(line[i + 1]))
		var s_on_seg := next_s - l[i]
		var t: float = clamp(s_on_seg / seg_len, 0.0, 1.0)
		var a := line[i]
		var b := line[i + 1]
		var pos := a.lerp(b, t)
		var dir := (b - a) / seg_len
		var rot := atan2(dir.y, dir.x)
		var deg := rad_to_deg(rot)
		if deg > 90.0 or deg < -90.0:
			rot += PI
			dir = -dir

		out.append({"s": next_s, "pos": pos, "dir": dir, "rot": rot})
		next_s += spacing
	return out
```
