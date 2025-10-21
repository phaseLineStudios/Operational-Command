# ScenarioEditorOverlay::_draw_task_glyph Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 477–488)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_task_glyph(inst: ScenarioTask, center: Vector2, hi: bool) -> void
```

## Description

Delegate task glyph drawing to the task resource

## Source

```gdscript
func _draw_task_glyph(inst: ScenarioTask, center: Vector2, hi: bool) -> void:
	if inst == null or inst.task == null:
		return
	var to_map := Callable(editor.terrain_render, "terrain_to_map")
	var scale_icon := Callable(self, "_scale_icon")
	inst.task.draw_glyph(
		self, center, hi, hover_scale, task_icon_px, task_icon_inner_px, inst, to_map, scale_icon
	)
	if hi and inst.task:
		_draw_title(inst.task.display_name, center)
```
