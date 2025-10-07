# SlotItem::_apply_style Function Reference

*Defined at:* `scripts/ui/helpers/SlotItem.gd` (lines 122–140)</br>
*Belongs to:* [SlotItem](../../SlotItem.md)

**Signature**

```gdscript
func _apply_style() -> void
```

## Description

Apply style

## Source

```gdscript
func _apply_style() -> void:
	if _deny_hover and deny_hover_style:
		add_theme_stylebox_override("panel", deny_hover_style)
	elif _assigned_unit:
		if _is_hovered and hover_style_filled:
			add_theme_stylebox_override("panel", hover_style_filled)
		elif filled_style:
			add_theme_stylebox_override("panel", filled_style)
		elif _base_style:
			add_theme_stylebox_override("panel", _base_style)
	else:
		if _is_hovered and hover_style_empty:
			add_theme_stylebox_override("panel", hover_style_empty)
		elif _base_style:
			add_theme_stylebox_override("panel", _base_style)
		else:
			remove_theme_stylebox_override("panel")
```
