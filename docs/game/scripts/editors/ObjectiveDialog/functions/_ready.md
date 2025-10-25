# ObjectiveDialog::_ready Function Reference

*Defined at:* `scripts/editors/ObjectiveDialog.gd` (lines 27–32)</br>
*Belongs to:* [ObjectiveDialog](../../ObjectiveDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Wire UI elements.

## Source

```gdscript
func _ready() -> void:
	_save.pressed.connect(_on_save)
	_cancel.pressed.connect(_on_cancel)
	close_requested.connect(_on_cancel)
```
