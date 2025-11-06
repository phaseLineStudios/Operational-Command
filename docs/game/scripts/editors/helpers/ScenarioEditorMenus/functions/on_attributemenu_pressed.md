# ScenarioEditorMenus::on_attributemenu_pressed Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorMenus.gd` (lines 39–65)</br>
*Belongs to:* [ScenarioEditorMenus](../../ScenarioEditorMenus.md)

**Signature**

```gdscript
func on_attributemenu_pressed(id: int) -> void
```

- **id**: Menu item ID.

## Description

Handle Attributes menu actions (Edit Scenario/Briefing/Weather).

## Source

```gdscript
func on_attributemenu_pressed(id: int) -> void:
	match id:
		0:
			if editor.ctx.data:
				editor.new_scenario_dialog.show_dialog(true, editor.ctx.data)
			else:
				editor.new_scenario_dialog.show_dialog(true)
		1:
			if editor.ctx.data == null:
				var acc := AcceptDialog.new()
				acc.title = "Briefing"
				acc.dialog_text = "Create a scenario first."
				editor.add_child(acc)
				acc.popup_centered()
				return
			editor.brief_dialog.show_dialog(true, editor.ctx.data.briefing)
		2:
			if editor.ctx.data == null:
				var acc := AcceptDialog.new()
				acc.title = "Weather"
				acc.dialog_text = "Create a scenario first."
				editor.add_child(acc)
				acc.popup_centered()
				return
			editor.weather_dialog.show_dialog(true)
```
