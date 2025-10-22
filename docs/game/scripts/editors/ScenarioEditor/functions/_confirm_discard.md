# ScenarioEditor::_confirm_discard Function Reference

*Defined at:* `scripts/editors/ScenarioEditor.gd` (lines 875–890)</br>
*Belongs to:* [ScenarioEditor](../../ScenarioEditor.md)

**Signature**

```gdscript
func _confirm_discard() -> bool
```

## Description

Confirm discarding unsaved changes; returns true if accepted

## Source

```gdscript
func _confirm_discard() -> bool:
	var acc := ConfirmationDialog.new()
	acc.title = "Unsaved changes"
	acc.dialog_text = "You have unsaved changes. Discard and continue?"
	add_child(acc)
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
