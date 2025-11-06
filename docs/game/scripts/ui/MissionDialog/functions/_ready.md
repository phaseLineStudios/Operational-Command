# MissionDialog::_ready Function Reference

*Defined at:* `scripts/ui/MissionDialog.gd` (lines 28–36)</br>
*Belongs to:* [MissionDialog](../../MissionDialog.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	visible = false
	if _ok_button:
		_ok_button.pressed.connect(_on_ok_pressed)
	if _line_overlay:
		_line_overlay.draw.connect(_draw_line)
		_line_overlay.visible = false
```
