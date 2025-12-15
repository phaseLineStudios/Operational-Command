# ScenarioEditorMenus::on_filemenu_pressed Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 23–36)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func on_filemenu_pressed(id: int) -> void
```

- **id**: Menu item ID.

## Description

Handle File menu actions (New/Open/Save/Save As/Back).

## Source

```gdscript
func on_filemenu_pressed(id: int) -> void:
	match id:
		0:
			editor.new_scenario_dialog.show_dialog(true)
		1:
			editor.file_ops.cmd_open()
		2:
			editor.file_ops.cmd_save()
		3:
			editor.file_ops.cmd_save_as()
		4:
			_on_quit_requested()
```
