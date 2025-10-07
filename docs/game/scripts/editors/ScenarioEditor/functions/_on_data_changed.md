# ScenarioEditor::_on_data_changed Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 728–739)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_data_changed() -> void
```

## Description

Refresh UI/overlay/tree after data changes

## Source

```gdscript
func _on_data_changed() -> void:
	title_label.text = ctx.data.title
	if ctx.data and ctx.data.terrain:
		terrain_render.data = ctx.data.terrain
	else:
		mouse_position_label.text = ""
	ctx.request_overlay_redraw()
	_rebuild_scene_tree()
	_on_history_changed([], [])
	units._refresh(ctx)
```
