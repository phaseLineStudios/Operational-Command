# MissionDialog::_ready Function Reference

*Defined at:* `scripts/ui/MissionDialog.gd` (lines 32–45)</br>
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

	# Setup drag functionality
	if _drag_bar:
		_drag_bar.gui_input.connect(_on_drag_bar_input)
		_drag_bar.mouse_filter = Control.MOUSE_FILTER_STOP
```
