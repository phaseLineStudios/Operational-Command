# BriefingDialog::_ready Function Reference

*Defined at:* `scripts/editors/BriefingDialog.gd` (lines 33–41)</br>
*Belongs to:* [BriefingDialog](../../BriefingDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Wire buttons.

## Source

```gdscript
func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	objective_add.pressed.connect(_on_add_objective)
	objective_dialog.request_create.connect(_on_objective_create)
	objective_dialog.request_update.connect(_on_objective_update)
```
