# ScenarioEditor::_on_filemenu_pressed Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 625–638)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_filemenu_pressed(id: int)
```

## Description

File menu actions (New/Open/Save/Save As/Back)

## Source

```gdscript
func _on_filemenu_pressed(id: int):
	match id:
		0:
			new_scenario_dialog.show_dialog(true)
		1:
			_cmd_open()
		2:
			_cmd_save()
		3:
			_cmd_save_as()
		4:
			Game.goto_scene(MAIN_MENU_SCENE)
```
