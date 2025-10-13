# ScenarioEditorOverlay::_draw_arrow Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 490–498)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_arrow(a: Vector2, b: Vector2, col: Color, head_len: float = arrow_head_len_px) -> void
```

## Description

Draw an arrow line with two head strokes

## Source

```gdscript
func _draw_arrow(a: Vector2, b: Vector2, col: Color, head_len: float = arrow_head_len_px) -> void:
	draw_line(a, b, col, 2.0, true)
	var dir := (b - a).normalized()
	var side := dir.rotated(0.8) * head_len
	var side2 := dir.rotated(-0.8) * head_len
	draw_line(b, b - side, col, 2.0, true)
	draw_line(b, b - side2, col, 2.0, true)
```
