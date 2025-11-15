# ScenarioEditorOverlay::_pick_at Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 574–629)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _pick_at(overlay_pos: Vector2) -> Dictionary
```

## Description

Hit-test the closest entity under the overlay position

## Source

```gdscript
func _pick_at(overlay_pos: Vector2) -> Dictionary:
	var best := {}
	var best_d2 := INF

	var slot_r := float(slot_icon_px) * 0.5 + 2.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.unit_slots:
		for i in editor.ctx.data.unit_slots.size():
			var entry = editor.ctx.data.unit_slots[i]
			if entry == null:
				continue
			var pos_m := _slot_pos_m(entry)
			var sp := editor.terrain_render.terrain_to_map(pos_m)
			var d2 := sp.distance_squared_to(overlay_pos)
			if d2 <= slot_r * slot_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"slot", "index": i}

	var unit_r := float(unit_icon_px) * 0.5 + 2.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.units:
		for i in editor.ctx.data.units.size():
			var su: ScenarioUnit = editor.ctx.data.units[i]
			if su == null:
				continue
			var up := editor.terrain_render.terrain_to_map(su.position_m)
			var d2 := up.distance_squared_to(overlay_pos)
			if d2 <= unit_r * unit_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"unit", "index": i}

	var task_r := float(task_icon_px) * 0.5 + 4.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.tasks:
		for i in editor.ctx.data.tasks.size():
			var inst: ScenarioTask = editor.ctx.data.tasks[i]
			if inst == null:
				continue
			var tp := editor.terrain_render.terrain_to_map(inst.position_m)
			var d2 := tp.distance_squared_to(overlay_pos)
			if d2 <= task_r * task_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"task", "index": i}

	var trig_r := float(trigger_icon_px) * 0.5 + 4.0
	if editor and editor.ctx and editor.ctx.data and editor.ctx.data.triggers:
		for i in editor.ctx.data.triggers.size():
			var trig: ScenarioTrigger = editor.ctx.data.triggers[i]
			if trig == null:
				continue
			var tp := editor.terrain_render.terrain_to_map(trig.area_center_m)
			var d2 := tp.distance_squared_to(overlay_pos)
			if d2 <= trig_r * trig_r and d2 < best_d2:
				best_d2 = d2
				best = {"type": &"trigger", "index": i}

	return best
```
