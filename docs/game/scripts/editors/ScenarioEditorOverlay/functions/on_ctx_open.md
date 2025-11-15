# ScenarioEditorOverlay::on_ctx_open Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 117–152)</br>
*Belongs to:* [ScenarioEditorOverlay](../../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func on_ctx_open(event: InputEventMouseButton)
```

## Description

Open context menu at mouse position using current pick

## Source

```gdscript
func on_ctx_open(event: InputEventMouseButton):
	if not event:
		return
	_last_pick = _pick_at(event.position)

	_ctx.clear()
	_ctx.add_item("Map", -1)
	_ctx.set_item_disabled(0, true)
	_ctx.add_separator()

	match _last_pick.get("type", &""):
		&"slot":
			_ctx.add_item("Configure Slot", MI_CONFIG_SLOT)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		&"unit":
			_ctx.add_item("Configure Unit", MI_CONFIG_UNIT)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		&"task":
			_ctx.add_item("Configure Task", MI_CONFIG_TASK)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		&"trigger":
			_ctx.add_item("Configure Trigger", MI_CONFIG_TRIGGER)
			_ctx.add_separator()
			_ctx.add_item("Delete", MI_DELETE)
		_:
			_ctx.add_item("No actions here", -1)
			_ctx.set_item_disabled(_ctx.get_item_count() - 1, true)

	_ctx.position = event.position.floor()
	_ctx.reset_size()
	_ctx.popup()
```
