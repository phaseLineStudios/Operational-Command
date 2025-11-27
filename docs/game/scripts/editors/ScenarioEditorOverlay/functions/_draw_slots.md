# ScenarioEditorOverlay::_draw_slots Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 224–248)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _draw_slots() -> void
```

## Description

Draw all player slot glyphs and hover titles

## Source

```gdscript
func _draw_slots() -> void:
	if (
		not editor
		or not editor.ctx
		or not editor.ctx.data
		or not editor.ctx.data.terrain
		or editor.ctx.data.unit_slots == null
	):
		return
	var tex := _get_scaled_icon_slot()
	if tex == null:
		return
	for i in editor.ctx.data.unit_slots.size():
		var entry = editor.ctx.data.unit_slots[i]
		var pos_m := _slot_pos_m(entry)
		var pos: Vector2 = editor.terrain_render.terrain_to_map(pos_m)
		var hi := _is_highlighted(&"slot", i)
		_draw_icon_with_hover(tex, pos, hi)
		if hi:
			var title := "slot"
			if entry is UnitSlotData:
				title = (entry as UnitSlotData).title
			_draw_title(title, pos)
```
