# NewScenarioDialog::_on_primary_pressed Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 37–60)</br>
*Belongs to:* [NewScenarioDialog](../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_primary_pressed() -> void
```

## Source

```gdscript
func _on_primary_pressed() -> void:
	match dialog_mode:
		DialogMode.CREATE:
			if not terrain:
				push_warning("No terrain selected")
				return
			var sd := ScenarioData.new()
			sd.title = title_input.text
			sd.description = desc_input.text
			sd.preview = thumbnail
			sd.terrain = terrain
			emit_signal("request_create", sd)
		DialogMode.EDIT:
			if not working:
				push_warning("No scenario to update")
				return
			working.title = title_input.text
			working.description = desc_input.text
			working.preview = thumbnail
			working.terrain = terrain
			emit_signal("request_update", working)
	show_dialog(false)
```
