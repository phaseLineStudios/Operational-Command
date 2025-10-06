# ScenarioEditorOverlay::on_dbl_click Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 149–165)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func on_dbl_click(event: InputEventMouseButton)
```

## Description

Handle double-click on a glyph (open config)

## Source

```gdscript
func on_dbl_click(event: InputEventMouseButton):
	if not event:
		return
	var pick := _pick_at(event.position)
	match pick.get("type", &""):
		&"slot":
			editor._open_slot_config(pick["index"])
		&"unit":
			editor._open_unit_config(pick["index"])
		&"task":
			editor._open_task_config(pick["index"])
		&"trigger":
			editor._open_trigger_config(pick["index"])
		_:
			pass
```
