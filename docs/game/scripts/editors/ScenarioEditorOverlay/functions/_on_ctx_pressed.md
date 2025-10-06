# ScenarioEditorOverlay::_on_ctx_pressed Function Reference

*Defined at:* `scripts/editors/ScenarioEditorOverlay.gd` (lines 174–192)</br>
*Belongs to:* [ScenarioEditorOverlay](../ScenarioEditorOverlay.md)

**Signature**

```gdscript
func _on_ctx_pressed(id: int) -> void
```

## Description

Handle context menu actions for the last pick

## Source

```gdscript
func _on_ctx_pressed(id: int) -> void:
	match id:
		MI_CONFIG_SLOT:
			if _last_pick.get("type", &"") == &"slot":
				editor._open_slot_config(_last_pick["index"])
		MI_CONFIG_UNIT:
			if _last_pick.get("type", &"") == &"unit":
				editor._open_unit_config(_last_pick["index"])
		MI_CONFIG_TASK:
			if _last_pick.get("type", &"") == &"task":
				editor._open_task_config(_last_pick["index"])
		MI_CONFIG_TRIGGER:
			if _last_pick.get("type", &"") == &"trigger":
				editor._open_trigger_config(_last_pick["index"])
		MI_DELETE:
			if not _last_pick.is_empty():
				editor._delete_pick(_last_pick)
```
