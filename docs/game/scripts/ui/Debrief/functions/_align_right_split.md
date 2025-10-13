# Debrief::_align_right_split Function Reference

*Defined at:* `scripts/ui/Debrief.gd` (lines 396–413)</br>
*Belongs to:* [Debrief](../../Debrief.md)

**Signature**

```gdscript
func _align_right_split() -> void
```

## Description

Computes the required commendation panel height so the bottom of the Units area
aligns with the bottom of the Casualties panel, without shrinking below
MIN_COMMEND_PANEL_HEIGHT.

## Source

```gdscript
func _align_right_split() -> void:
	if _left_col == null or _right_col == null:
		return
	var sep_l := _left_col.get_theme_constant("separation")
	var sep_r := _right_col.get_theme_constant("separation")

	var target_units_h := (
		_left_objectives_panel.size.y
		+ sep_l
		+ _left_score_panel.size.y
		+ sep_l
		+ _left_casualties_panel.size.y
	)
	var desired_comm: float = max(
		MIN_COMMEND_PANEL_HEIGHT, _right_col.size.y - target_units_h - float(sep_r)
	)

	_right_commend_panel.custom_minimum_size = Vector2(0, desired_comm)
```
