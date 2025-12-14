# UnitSelect::_on_card_selected Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 375–382)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

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
	_selected_unit_for_supply = unit
	_populate_supply_ui(unit)
	_populate_replacements_ui(unit)
```
