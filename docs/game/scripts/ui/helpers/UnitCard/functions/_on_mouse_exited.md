# UnitCard::_on_mouse_exited Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 114–118)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func _on_mouse_exited() -> void
```

## Description

Hover-out visual feedback.

## Source

```gdscript
func _on_mouse_exited() -> void:
	_is_hovered = false
	_update_style()
```
