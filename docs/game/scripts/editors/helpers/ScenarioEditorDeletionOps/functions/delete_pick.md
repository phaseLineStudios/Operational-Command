# ScenarioEditorDeletionOps::delete_pick Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorDeletionOps.gd` (lines 20–33)</br>
*Belongs to:* [ScenarioEditorDeletionOps](../../ScenarioEditorDeletionOps.md)

**Signature**

```gdscript
func delete_pick(pick: Dictionary) -> void
```

- **pick**: Selection dictionary with "type" and "index".

## Description

Route deletion to the correct entity handler.

## Source

```gdscript
func delete_pick(pick: Dictionary) -> void:
	match StringName(pick.get("type", "")):
		&"unit":
			delete_unit(int(pick["index"]))
		&"slot":
			delete_slot(int(pick["index"]))
		&"task":
			delete_task(int(pick["index"]))
		&"trigger":
			delete_trigger(int(pick["index"]))
		_:
			pass
```
