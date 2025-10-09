# SlotConfigDialog::_ready Function Reference

*Defined at:* `scripts/editors/SlotConfigDialog.gd` (lines 19–25)</br>
*Belongs to:* [SlotConfigDialog](../../SlotConfigDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	save_btn.pressed.connect(_on_save)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	roles_add.pressed.connect(_on_role_add)
```
