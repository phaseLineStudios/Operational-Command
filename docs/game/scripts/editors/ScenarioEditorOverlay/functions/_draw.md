# ScenarioEditorOverlay::_draw Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 71–88)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw() -> void
```

## Description

Main overlay draw: links first, then glyphs, then active tool

## Source

```gdscript
func _draw() -> void:
	_draw_task_links()
	_draw_sync_links()
	_draw_units()
	_draw_slots()
	_draw_tasks()
	_draw_triggers()

	if _link_preview_active:
		var a := _screen_pos_for_pick(_link_preview_src)
		var b := _link_preview_pos
		draw_line(a, b, sync_line_color, sync_line_width, true)

	# draw active tool ghosts (use the SAME ref you checked)
	if editor and editor.ctx and editor.ctx.current_tool:
		editor.ctx.current_tool.draw_overlay(self)
```
