# MissionSelect::_apply_transparent_button_style Function Reference

*Defined at:* `scripts/ui/MissionSelect.gd` (lines 147–155)</br>
*Belongs to:* [MissionSelect](../../MissionSelect.md)

**Signature**

```gdscript
func _apply_transparent_button_style(btn: Button) -> void
```

## Description

Remove all button styleboxes so only icon/text remains.

## Source

```gdscript
func _apply_transparent_button_style(btn: Button) -> void:
	var empty := StyleBoxEmpty.new()
	btn.add_theme_stylebox_override("normal", empty)
	btn.add_theme_stylebox_override("hover", empty)
	btn.add_theme_stylebox_override("pressed", empty)
	btn.add_theme_stylebox_override("disabled", empty)
	btn.add_theme_stylebox_override("focus", empty)
```
