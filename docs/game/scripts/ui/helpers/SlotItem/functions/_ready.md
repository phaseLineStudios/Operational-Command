# SlotItem::_ready Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 42–67)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func _ready() -> void
```

## Description

Cache base style, wire hover, set mouse filters, and refresh visuals.

## Source

```gdscript
func _ready() -> void:
	var sb := get_theme_stylebox("panel")
	if sb:
		_base_style = sb.duplicate()

	_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lbl_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_lbl_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_entered.connect(
		func():
			_is_hovered = true
			_apply_style()
	)
	mouse_exited.connect(
		func():
			_is_hovered = false
			_deny_hover = false
			_apply_style()
	)
	_refresh_labels()
	_update_icon()
	_apply_style()
```
