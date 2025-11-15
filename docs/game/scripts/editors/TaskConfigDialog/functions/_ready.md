# TaskConfigDialog::_ready Function Reference

*Defined at:* `scripts/editors/TaskConfigDialog.gd` (lines 20–25)</br>
*Belongs to:* [TaskConfigDialog](../../TaskConfigDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): visible = false)
	close_requested.connect(func(): visible = false)
```
