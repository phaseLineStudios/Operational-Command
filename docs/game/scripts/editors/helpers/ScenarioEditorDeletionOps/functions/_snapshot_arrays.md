# ScenarioEditorDeletionOps::_snapshot_arrays Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd` (lines 230–248)</br>
*Belongs to:* [ScenarioEditorDeletionOps](../../ScenarioEditorDeletionOps.md)

**Signature**

```gdscript
func _snapshot_arrays() -> Dictionary
```

- **Return Value**: Dictionary with deep copies of units, unit_slots, tasks, and triggers arrays.

## Description

Deep-copy key arrays for history operations.

## Source

```gdscript
func _snapshot_arrays() -> Dictionary:
	return {
		"units":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.units if editor.ctx.data and editor.ctx.data.units else []
		),
		"unit_slots":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.unit_slots if editor.ctx.data and editor.ctx.data.unit_slots else []
		),
		"tasks":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.tasks if editor.ctx.data and editor.ctx.data.tasks else []
		),
		"triggers":
		ScenarioHistory._deep_copy_array_res(
			editor.ctx.data.triggers if editor.ctx.data and editor.ctx.data.triggers else []
		),
	}
```
