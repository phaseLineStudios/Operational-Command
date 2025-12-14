# UnitCard::set_selected Function Reference

*Defined at:* `scripts/ui/helpers/UnitCard.gd` (lines 87–91)</br>
*Belongs to:* [UnitCard](../../UnitCard.md)

**Signature**

```gdscript
func set_selected(v: bool) -> void
```

## Description

Mark card as selected by the controller.

## Source

```gdscript
func set_selected(v: bool) -> void:
	_is_selected = v
	_update_style()
```
