# UnitSelect::_update_card_selection Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 384–394)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _update_card_selection(unit: UnitData) -> void
```

## Description

Highlight the selected card in the pool

## Source

```gdscript
func _update_card_selection(unit: UnitData) -> void:
	if _selected_card and is_instance_valid(_selected_card):
		_selected_card.set_selected(false)

	if _cards_by_unit.has(unit.id):
		var c: UnitCard = _cards_by_unit[unit.id]
		if is_instance_valid(c) and c.visible:
			_selected_card = c
			_selected_card.set_selected(true)
```
