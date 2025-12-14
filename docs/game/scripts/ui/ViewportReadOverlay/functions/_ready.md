# ViewportReadOverlay::_ready Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 20–32)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_background.mouse_filter = Control.MOUSE_FILTER_STOP
	_texture_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.mouse_filter = Control.MOUSE_FILTER_STOP

	_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	_close_button.pressed.connect(close)
	_background.gui_input.connect(_on_background_gui_input)
	_texture_rect.gui_input.connect(_on_texture_gui_input)
```
