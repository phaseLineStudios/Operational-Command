# UnitCard::_on_mouse_entered Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 106–110)</br>
*Belongs to:* [UnitCard](../UnitCard.md)

**Signature**

```gdscript
func _on_mouse_entered() -> void
```

## Description

Hover-in visual feedback.

## Source

```gdscript
func _on_mouse_entered() -> void:
	_is_hovered = true
	_update_style()
```
