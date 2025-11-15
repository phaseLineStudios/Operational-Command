# ScenarioEditorOverlay::_draw_tasks Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 250–261)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_tasks() -> void
```

## Description

Draw all task glyphs and hover titles

## Source

```gdscript
func _draw_tasks() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.tasks == null:
		return
	for i in editor.ctx.data.tasks.size():
		var inst: ScenarioTask = editor.ctx.data.tasks[i]
		if inst == null:
			continue
		var p := editor.terrain_render.terrain_to_map(inst.position_m)
		var hi := _is_highlighted(&"task", i)
		_draw_task_glyph(inst, p, hi)
```
