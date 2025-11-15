# ScenarioEditorOverlay::_draw_triggers Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 303–316)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_triggers() -> void
```

## Description

Draw trigger areas (circle/rect), outlines, and optional icon/title

## Source

```gdscript
func _draw_triggers() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.triggers == null:
		return
	for i in editor.ctx.data.triggers.size():
		var trig: ScenarioTrigger = editor.ctx.data.triggers[i]
		if trig == null:
			continue
		var center_px := editor.terrain_render.terrain_to_map(trig.area_center_m)
		var hi := _is_highlighted(&"trigger", i)
		_draw_trigger_shape(trig, center_px, hi)
		if hi and trig.title != "":
			_draw_title(trig.title, center_px)
```
