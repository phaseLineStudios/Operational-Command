# ScenarioEditorOverlay::on_dbl_click Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 154–170)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

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
			editor.menus.open_slot_config(pick["index"])
		&"unit":
			editor.menus.open_unit_config(pick["index"])
		&"task":
			editor.menus.open_task_config(pick["index"])
		&"trigger":
			editor.menus.open_trigger_config(pick["index"])
		_:
			pass
```
