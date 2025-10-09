# ScenarioEditor::_on_attributemenu_pressed Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 642–658)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_attributemenu_pressed(id: int)
```

## Description

Attributes menu actions (Edit Scenario/Briefing/Weather)

## Source

```gdscript
func _on_attributemenu_pressed(id: int):
	match id:
		0:
			if ctx.data:
				new_scenario_dialog.show_dialog(true, ctx.data)
			else:
				new_scenario_dialog.show_dialog(true)
		1:
			var acc := AcceptDialog.new()
			acc.title = "Briefing"
			acc.dialog_text = "Briefing tool not yet implemented."
			add_child(acc)
			acc.popup_centered()
		2:
			%WeatherDialog.show_dialog(true)
```
