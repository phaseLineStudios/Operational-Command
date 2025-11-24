# OCMenuWindow::popup_centered Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 54–68)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func popup_centered() -> void
```

## Description

Show dialog centered in parent Control or viewport.

## Source

```gdscript
func popup_centered() -> void:
	visible = true
	move_to_front()

	var ref_size := _get_reference_rect_size()
	var current_size := size

	if current_size == Vector2.ZERO:
		current_size = custom_minimum_size
		if current_size == Vector2.ZERO:
			current_size = Vector2(300.0, 200.0)

	position = ((ref_size - current_size) * 0.5).round()
```
