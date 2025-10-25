# ObjectiveDialog::_on_cancel Function Reference

*Defined at:* `scripts/editors/ObjectiveDialog.gd` (lines 74–76)</br>
*Belongs to:* [ObjectiveDialog](../../ObjectiveDialog.md)

**Signature**

```gdscript
func _on_cancel() -> void
```

## Description

Called when dialog gets cancelled.

## Source

```gdscript
func _on_cancel() -> void:
	hide()
	emit_signal("canceled")
```
