# OCMenuWindow::popup_centered_ratio Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 71–83)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func popup_centered_ratio(ratio: float = 0.75) -> void
```

- **ratio**: Size ratio relative to reference rect (0-1).

## Description

Show dialog centered and sized to `ratio` of parent/viewport.

## Source

```gdscript
func popup_centered_ratio(ratio: float = 0.75) -> void:
	ratio = clampf(ratio, 0.0, 1.0)

	visible = true
	move_to_front()

	var ref_size := _get_reference_rect_size()
	var new_size := ref_size * ratio

	size = new_size
	position = ((ref_size - new_size) * 0.5).round()
```
