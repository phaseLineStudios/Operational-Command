# UnitPlaceTool::_place Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 95–109)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

**Signature**

```gdscript
func _place() -> void
```

## Source

```gdscript
func _place() -> void:
	if payload is UnitData:
		if _is_already_used(editor.ctx, payload):
			push_warning("That unit is already placed.")
			emit_signal("canceled")
			return

		editor._place_unit_from_tool(payload, _hover_map_pos)
		emit_signal("finished")
	elif payload is UnitSlotData:
		editor._place_slot_from_tool(payload, _hover_map_pos)
	else:
		emit_signal("finished")
```
