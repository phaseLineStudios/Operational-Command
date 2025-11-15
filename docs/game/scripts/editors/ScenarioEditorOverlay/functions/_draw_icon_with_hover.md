# ScenarioEditorOverlay::_draw_icon_with_hover Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 501–511)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_icon_with_hover(tex: Texture2D, center: Vector2, hovered: bool) -> void
```

## Description

Draw a texture centered, with hover scale/opacity feedback

## Source

```gdscript
func _draw_icon_with_hover(tex: Texture2D, center: Vector2, hovered: bool) -> void:
	var icon_size: Vector2 = tex.get_size()
	var half := icon_size * 0.5
	if hovered:
		draw_set_transform(center, 0.0, Vector2.ONE * hover_scale)
		draw_texture(tex, -half)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		draw_texture(tex, center - half, Color(1, 1, 1, 0.75))
```
