# UnitStrengthBadge::_ensure_ui Function Reference

*Defined at:* `scripts/ui/widgets/UnitStrengthBadge.gd` (lines 12–24)</br>
*Belongs to:* [UnitStrengthBadge](../../UnitStrengthBadge.md)

**Signature**

```gdscript
func _ensure_ui() -> void
```

## Description

Create child UI nodes if needed. Safe to call before _ready().

## Source

```gdscript
func _ensure_ui() -> void:
	if _status_rect == null:
		_status_rect = ColorRect.new()
		_status_rect.custom_minimum_size = Vector2(12, 12)
		add_child(_status_rect)
	if _percent_lbl == null:
		_percent_lbl = Label.new()
		_percent_lbl.custom_minimum_size = Vector2(40, 0)
		_percent_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		add_child(_percent_lbl)
	add_theme_constant_override("separation", 4)
```
