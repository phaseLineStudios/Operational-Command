# SymbolDrawingTool::_ready Function Reference

*Defined at:* `scripts/test/SymbolDrawingTool.gd` (lines 47–64)</br>
*Belongs to:* [SymbolDrawingTool](../../SymbolDrawingTool.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	clear_btn.pressed.connect(_on_clear_pressed)
	generate_btn.pressed.connect(_on_generate_pressed)
	copy_btn.pressed.connect(_on_copy_pressed)
	delete_btn.pressed.connect(_on_delete_pressed)

	line_btn.pressed.connect(func(): _set_tool(ShapeType.LINE))
	circle_btn.pressed.connect(func(): _set_tool(ShapeType.CIRCLE))
	ellipse_btn.pressed.connect(func(): _set_tool(ShapeType.ELLIPSE))
	rect_btn.pressed.connect(func(): _set_tool(ShapeType.RECTANGLE))

	filled_check.toggled.connect(func(value): _current_filled = value)
	corner_slider.value_changed.connect(_on_corner_radius_changed)

	canvas.draw.connect(_on_canvas_draw)
	_set_tool(ShapeType.LINE)
```
