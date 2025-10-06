# ScenarioEditorOverlay::_draw_sync_links Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 345–367)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_sync_links() -> void
```

## Description

Draw all synchronization lines from triggers to units/tasks

## Source

```gdscript
func _draw_sync_links() -> void:
	if not editor or not editor.ctx or not editor.ctx.data or editor.ctx.data.triggers == null:
		return
	for trig: ScenarioTrigger in editor.ctx.data.triggers:
		if trig == null:
			continue
		var tp := editor.terrain_render.terrain_to_map(trig.area_center_m)
		if trig.synced_units:
			for ui in trig.synced_units:
				if editor.ctx.data.units and ui >= 0 and ui < editor.ctx.data.units.size():
					var su: ScenarioUnit = editor.ctx.data.units[ui]
					if su:
						var up := editor.terrain_render.terrain_to_map(su.position_m)
						draw_line(up, tp, sync_line_color, sync_line_width, true)
		if trig.synced_tasks:
			for ti in trig.synced_tasks:
				if editor.ctx.data.tasks and ti >= 0 and ti < editor.ctx.data.tasks.size():
					var inst: ScenarioTask = editor.ctx.data.tasks[ti]
					if inst:
						var p := editor.terrain_render.terrain_to_map(inst.position_m)
						draw_line(p, tp, sync_line_color, sync_line_width, true)
```
