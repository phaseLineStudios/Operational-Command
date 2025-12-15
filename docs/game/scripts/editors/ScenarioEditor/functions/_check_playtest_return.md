# ScenarioEditor::_check_playtest_return Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 729–754)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _check_playtest_return() -> void
```

## Description

Check if returning from playtest and restore state

## Source

```gdscript
func _check_playtest_return() -> void:
	if Game.playtest_history_state.is_empty():
		return

	# Reload the scenario that was being edited
	var file_path := Game.playtest_file_path
	if file_path.strip_edges() != "":
		if persistence.load_from_path(ctx, file_path):
			file_ops.current_path = file_path
			file_ops.dirty = false
			LogService.info("Reloaded scenario after playtest: %s" % file_path, "ScenarioEditor")
			_on_data_changed()

	# Wait for history to be initialized
	await get_tree().process_frame

	# Restore history state
	if history:
		history.restore_state(Game.playtest_history_state)
		LogService.info("Restored playtest history state", "ScenarioEditor")

	# Clear the playtest state
	Game.playtest_history_state = {}
	Game.playtest_file_path = ""
```
