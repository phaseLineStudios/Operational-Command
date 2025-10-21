# ScenarioEditor::_delete_pick Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 443–456)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _delete_pick(pick: Dictionary) -> void
```

## Description

Route deletion to the correct entity handler

## Source

```gdscript
func _delete_pick(pick: Dictionary) -> void:
	match StringName(pick.get("type", "")):
		&"unit":
			_delete_unit(int(pick["index"]))
		&"slot":
			_delete_slot(int(pick["index"]))
		&"task":
			_delete_task(int(pick["index"]))
		&"trigger":
			_delete_trigger(int(pick["index"]))
		_:
			pass
```
