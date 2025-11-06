# TriggerConfigDialog::_exit_tree Function Reference

*Defined at:* `scripts/editors/TriggerConfigDialog.gd` (lines 43–52)</br>
*Belongs to:* [TriggerConfigDialog](../../TriggerConfigDialog.md)

**Signature**

```gdscript
func _exit_tree() -> void
```

## Source

```gdscript
func _exit_tree() -> void:
	# Cleanup autocomplete helpers
	if _autocomplete_condition:
		_autocomplete_condition.detach()
	if _autocomplete_activate:
		_autocomplete_activate.detach()
	if _autocomplete_deactivate:
		_autocomplete_deactivate.detach()
```
