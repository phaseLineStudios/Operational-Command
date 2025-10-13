# TriggerConfigDialog::_ready Function Reference

*Defined at:* `scripts/editors/TriggerConfigDialog.gd` (lines 24–29)</br>
*Belongs to:* [TriggerConfigDialog](../../TriggerConfigDialog.md)

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
