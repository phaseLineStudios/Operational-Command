# ScenarioEditorOverlay::_draw_units Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 194–216)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_units() -> void
```

## Description

Draw all unit glyphs and hover titles

## Source

```gdscript
func _draw_units() -> void:
	if (
		not editor
		or not editor.ctx
		or not editor.ctx.data
		or not editor.ctx.data.terrain
		or editor.ctx.data.units == null
	):
		return
	for i in editor.ctx.data.units.size():
		var su: ScenarioUnit = editor.ctx.data.units[i]
		if su == null or su.unit == null:
			continue
		var tex := _get_scaled_icon_unit(su)
		if tex == null:
			continue
		var pos: Vector2 = editor.terrain_render.terrain_to_map(su.position_m)
		var hi := _is_highlighted(&"unit", i)
		_draw_icon_with_hover(tex, pos, hi)
		if hi:
			_draw_title(su.callsign, pos)
```
