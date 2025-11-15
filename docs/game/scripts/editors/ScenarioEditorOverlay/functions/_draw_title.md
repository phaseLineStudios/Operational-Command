# ScenarioEditorOverlay::_draw_title Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 513–532)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_title(text: String, center: Vector2) -> void
```

## Description

Draw a small label next to a glyph

## Source

```gdscript
func _draw_title(text: String, center: Vector2) -> void:
	var font := get_theme_default_font()
	var fs := get_theme_default_font_size()
	if font == null:
		return
	var pos := center + hover_title_offset
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var rect := Rect2(Vector2(pos.x - w * 0.5 - 4, pos.y - fs - 4), Vector2(w + 8, fs + 8))
	draw_rect(rect, Color(0, 0, 0, 0.55), true)
	draw_string(
		font,
		Vector2(pos.x - w * 0.5, pos.y),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		fs,
		Color(1, 1, 1, 0.96)
	)
```
