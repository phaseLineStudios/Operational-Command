# ScenarioEditorFileOps::confirm_discard Function Reference

*Defined at:* `scripts/editors/helpers/ScenarioEditorFileOps.gd` (lines 126–141)</br>
*Belongs to:* [ScenarioEditorFileOps](../../ScenarioEditorFileOps.md)

**Signature**

```gdscript
func confirm_discard() -> bool
```

- **Return Value**: True if user confirmed discard.

## Description

Confirm discarding unsaved changes; returns true if accepted.

## Source

```gdscript
func confirm_discard() -> bool:
	var acc := ConfirmationDialog.new()
	acc.title = "Unsaved changes"
	acc.dialog_text = "You have unsaved changes. Discard and continue?"
	editor.add_child(acc)
	var accepted := false
	@warning_ignore("confusable_capture_reassignment")
	acc.canceled.connect(func(): accepted = false)
	@warning_ignore("confusable_capture_reassignment")
	acc.confirmed.connect(func(): accepted = true)
	acc.popup_centered()
	await acc.confirmed
	acc.queue_free()
	return accepted
```
