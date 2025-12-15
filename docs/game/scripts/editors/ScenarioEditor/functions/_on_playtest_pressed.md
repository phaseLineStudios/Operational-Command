# ScenarioEditor::_on_playtest_pressed Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 700–727)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _on_playtest_pressed() -> void
```

## Description

Handle PlayTest button press

## Source

```gdscript
func _on_playtest_pressed() -> void:
	if not ctx.data:
		push_warning("Cannot playtest: no scenario loaded")
		return

	# Auto-save scenario before playtesting
	if file_ops.current_path.strip_edges() == "":
		# No path set - prompt for save location
		file_ops.cmd_save_as()
		await file_ops.save_dlg.file_selected
		# If user cancelled, don't start playtest
		if file_ops.current_path.strip_edges() == "":
			return
	else:
		# Save to current path
		file_ops.cmd_save()

	# Serialize history state for restoration
	var history_state := {}
	if history:
		history_state = history.serialize_state()

	# Start playtest mode
	Game.start_playtest(
		ctx.data, "res://scenes/scenario_editor.tscn", file_ops.current_path, history_state
	)
```
