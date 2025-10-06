# ScenarioEditorOverlay::_trim_segment Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 656–664)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _trim_segment(src: Vector2, dst: Vector2, src_trim: float, dst_trim: float) -> Array[Vector2]
```

## Description

Shorten a segment at both ends by given trims (pixels)

## Source

```gdscript
func _trim_segment(src: Vector2, dst: Vector2, src_trim: float, dst_trim: float) -> Array[Vector2]:
	var dir := dst - src
	var l := dir.length()
	if l <= 1.0:
		return [src, dst]
	var n := dir / l
	var a := src + n * src_trim
	var b := dst - n * dst_trim
	return [a, b]
```
