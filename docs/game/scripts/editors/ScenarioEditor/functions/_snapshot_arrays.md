# ScenarioEditor::_snapshot_arrays Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 627–643)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _snapshot_arrays() -> Dictionary
```

## Description

Deep-copy key arrays for history operations

## Source

```gdscript
func _snapshot_arrays() -> Dictionary:
	return {
		"units":
		ScenarioHistory._deep_copy_array_res(ctx.data.units if ctx.data and ctx.data.units else []),
		"unit_slots":
		ScenarioHistory._deep_copy_array_res(
			ctx.data.unit_slots if ctx.data and ctx.data.unit_slots else []
		),
		"tasks":
		ScenarioHistory._deep_copy_array_res(ctx.data.tasks if ctx.data and ctx.data.tasks else []),
		"triggers":
		ScenarioHistory._deep_copy_array_res(
			ctx.data.triggers if ctx.data and ctx.data.triggers else []
		),
	}
```
