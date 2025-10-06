# UnitSelect::_on_card_selected Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 345–349)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _on_card_selected(unit: UnitData) -> void
```

## Description

Handle card clicked in pool

## Source

```gdscript
func _on_card_selected(unit: UnitData) -> void:
	_show_unit_stats(unit)
	_update_card_selection(unit)
```
