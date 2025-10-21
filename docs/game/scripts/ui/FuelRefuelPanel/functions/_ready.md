# FuelRefuelPanel::_ready Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 31–43)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	# Make it look compact; let VBox drive the width
	add_theme_font_size_override("font_size", compact_font_size)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = 0
	custom_minimum_size.x = 0.0

	_btn_full.pressed.connect(_on_full)
	_btn_half.pressed.connect(_on_half)
	_btn_cancel.pressed.connect(func(): hide())
	_btn_commit.pressed.connect(_on_commit)
```
