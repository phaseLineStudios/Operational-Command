# ScenarioEditorOverlay::_draw_task_links Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 257–295)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_task_links() -> void
```

## Description

Draw task chain arrows between unit/task and next task

## Source

```gdscript
func _draw_task_links() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.tasks == null:
		return

	for i in editor.ctx.data.tasks.size():
		var inst: ScenarioTask = editor.ctx.data.tasks[i]
		if inst == null:
			continue

		var src_center := Vector2.ZERO
		var src_radius := 0.0
		if inst.prev_index >= 0 and inst.prev_index < editor.ctx.data.tasks.size():
			var prev: ScenarioTask = editor.ctx.data.tasks[inst.prev_index]
			if prev == null:
				continue
			src_center = editor.terrain_render.terrain_to_map(prev.position_m)
			src_radius = _glyph_radius(&"task", inst.prev_index)
		else:
			if inst.unit_index < 0 or inst.unit_index >= editor.ctx.data.units.size():
				continue
			var su: ScenarioUnit = editor.ctx.data.units[inst.unit_index]
			src_center = editor.terrain_render.terrain_to_map(su.position_m)
			src_radius = _glyph_radius(&"unit", inst.unit_index)

		var dst_center := editor.terrain_render.terrain_to_map(inst.position_m)
		var dst_radius := _glyph_radius(&"task", i)

		var a_b := _trim_segment(
			src_center, dst_center, src_radius + link_gap_px, dst_radius + link_gap_px
		)
		var a := a_b[0]
		var b := a_b[1]
		if a.distance_to(b) < 2.0:
			continue

		var col := inst.task.color if inst.task else Color.CYAN
		_draw_arrow(a, b, col, arrow_head_len_px)
```
