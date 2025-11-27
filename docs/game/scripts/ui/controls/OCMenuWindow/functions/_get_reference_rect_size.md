# OCMenuWindow::_get_reference_rect_size Function Reference

*Defined at:* `scripts/ui/controls/OcMenuWindow.gd` (lines 134–138)</br>
*Belongs to:* [OCMenuWindow](../../OCMenuWindow.md)

**Signature**

```gdscript
func _get_reference_rect_size() -> Vector2
```

- **Return Value**: Reference rect size for centering.

## Description

Get size of parent Control if available, otherwise viewport size.

## Source

```gdscript
func _get_reference_rect_size() -> Vector2:
	var parent_control := get_parent() as Control
	if parent_control != null:
		return parent_control.get_rect().size
	return get_viewport_rect().size
```
