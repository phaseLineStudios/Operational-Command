# SlotItem::_ready Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 53–82)</br>
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
			if hover_sounds.size() > 0 and _assigned_unit:
				AudioManager.play_random_ui_sound(
					hover_sounds, Vector2(1.0, 1.0), Vector2(0.98, 1.02)
				)
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
