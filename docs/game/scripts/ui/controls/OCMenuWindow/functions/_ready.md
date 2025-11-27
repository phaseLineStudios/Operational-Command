# OCMenuWindow::_ready Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 26–41)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	window = %DialogPanel
	close_button = %CloseButton
	cancel_button = %CancelButton
	ok_button = %OkButton
	_dragbar = %DragBar
	_title = %Title

	_title.text = window_title

	close_button.pressed.connect(_close_pressed)
	cancel_button.pressed.connect(_cancel_pressed)
	ok_button.pressed.connect(_ok_pressed)
	_dragbar.gui_input.connect(_on_dragbar_gui_input)
```
