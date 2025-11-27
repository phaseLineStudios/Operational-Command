# UnitCard::_update_style Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 82–92)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _update_style() -> void
```

## Description

Apply hover/selected panel styling.

## Source

```gdscript
func _update_style() -> void:
	if _is_selected and selected_style:
		add_theme_stylebox_override("panel", selected_style)
	elif _is_hovered and hover_style:
		add_theme_stylebox_override("panel", hover_style)
	elif _base_style:
		add_theme_stylebox_override("panel", _base_style)
	else:
		remove_theme_stylebox_override("panel")
```
