# NotificationBanner::_ready Function Reference

*Defined at:* `scripts/ui/NotificationBanner.gd` (lines 28–44)</br>
*Belongs to:* [NotificationBanner](../../NotificationBanner.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)

	var theme_style := get_theme_stylebox("panel")
	if theme_style and theme_style is StyleBoxFlat:
		_panel_style = (theme_style as StyleBoxFlat).duplicate()
		add_theme_stylebox_override("panel", _panel_style)
	else:
		_panel_style = StyleBoxFlat.new()
		_panel_style.bg_color = COLOR_NORMAL
		_panel_style.content_margin_left = 3.0
		_panel_style.content_margin_top = 3.0
		_panel_style.content_margin_right = 3.0
		_panel_style.content_margin_bottom = 3.0
		add_theme_stylebox_override("panel", _panel_style)
```
