# ScenarioTriggerTool::_on_mouse_button Function Reference

*Defined at:* `scripts/editors/tools/ScenarioTriggerTool.gd` (lines 38–63)</br>
*Belongs to:* [ScenarioTriggerTool](../../ScenarioTriggerTool.md)

**Signature**

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool
```

## Source

```gdscript
func _on_mouse_button(e: InputEventMouseButton) -> bool:
	if not e.pressed:
		return false
	match e.button_index:
		MOUSE_BUTTON_LEFT:
			if _hover_valid and prototype:
				var inst := ScenarioTrigger.new()
				inst.title = prototype.title
				inst.presence = prototype.presence
				inst.area_shape = prototype.area_shape
				inst.area_size_m = prototype.area_size_m
				inst.require_duration_s = prototype.require_duration_s
				inst.condition_expr = prototype.condition_expr
				inst.on_activate_expr = prototype.on_activate_expr
				inst.on_deactivate_expr = prototype.on_deactivate_expr
				editor._place_trigger_from_tool(inst, _hover_map_pos)
				editor._clear_tool()
				emit_signal("finished")
				return true
		MOUSE_BUTTON_RIGHT:
			editor._clear_tool()
			emit_signal("canceled")
			return true
	return false
```
