# ScenarioEditor::_on_ctx_selection_changed Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 192–205)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_ctx_selection_changed(payload: Dictionary) -> void
```

## Description

Handle palette selections (units, tasks, triggers)

## Source

```gdscript
func _on_ctx_selection_changed(payload: Dictionary) -> void:
	match StringName(payload.get("type", "")):
		&"palette":
			var pl: Variant = payload["payload"]
			if pl is UnitData or pl is UnitSlotData:
				_start_place_unit_tool(pl)
		&"task_palette":
			_start_place_task_tool(payload["task"])
		&"trigger_palette":
			_start_place_trigger_tool(payload["prototype"])
		_:
			pass
```
