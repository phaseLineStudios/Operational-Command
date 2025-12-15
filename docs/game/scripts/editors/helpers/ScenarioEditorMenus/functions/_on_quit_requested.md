# ScenarioEditorMenus::_on_quit_requested Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 108–112)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func _on_quit_requested() -> void
```

## Description

Handle quit request with unsaved changes confirmation

## Source

```gdscript
func _on_quit_requested() -> void:
	if editor.file_ops.is_dirty():
		if not await editor.file_ops.confirm_discard():
			return
	Game.goto_scene(MAIN_MENU_SCENE)
```
