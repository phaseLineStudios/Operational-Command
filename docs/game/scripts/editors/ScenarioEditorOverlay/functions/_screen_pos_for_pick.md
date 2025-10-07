# ScenarioEditorOverlay::_screen_pos_for_pick Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 390–434)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _screen_pos_for_pick(pick: Dictionary) -> Vector2
```

## Description

Return on-screen center of a given pick (fallback to hover pos)

## Source

```gdscript
func _screen_pos_for_pick(pick: Dictionary) -> Vector2:
	var t := StringName(pick.get("type", ""))
	var idx := int(pick.get("index", -1))
	if not editor or not editor.ctx or not editor.ctx.data:
		return _hover_pos
	match t:
		&"unit":
			if (
				editor.ctx.data.units
				and idx >= 0
				and idx < editor.ctx.data.units.size()
				and editor.ctx.data.units[idx]
			):
				return editor.terrain_render.terrain_to_map(editor.ctx.data.units[idx].position_m)
		&"slot":
			if (
				editor.ctx.data.unit_slots
				and idx >= 0
				and idx < editor.ctx.data.unit_slots.size()
				and editor.ctx.data.unit_slots[idx]
			):
				return editor.terrain_render.terrain_to_map(
					editor.ctx.data.unit_slots[idx].start_position
				)
		&"task":
			if (
				editor.ctx.data.tasks
				and idx >= 0
				and idx < editor.ctx.data.tasks.size()
				and editor.ctx.data.tasks[idx]
			):
				return editor.terrain_render.terrain_to_map(editor.ctx.data.tasks[idx].position_m)
		&"trigger":
			if (
				editor.ctx.data.triggers
				and idx >= 0
				and idx < editor.ctx.data.triggers.size()
				and editor.ctx.data.triggers[idx]
			):
				return editor.terrain_render.terrain_to_map(
					editor.ctx.data.triggers[idx].area_center_m
				)
	return _hover_pos
```
