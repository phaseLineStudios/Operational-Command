# UnitSelect::_build_pool Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 127–149)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _build_pool() -> void
```

## Description

Build the pool of recruitable unit cards

## Source

```gdscript
func _build_pool() -> void:
	_cards_by_unit.clear()
	_units_by_id.clear()
	for child in _pool.get_children():
		child.queue_free()

	var units: Array[UnitData] = ContentDB.list_recruitable_units(Game.current_scenario.id)
	for u in units:
		_units_by_id[u.id] = u

		var card: UnitCard = unit_card_scene.instantiate() as UnitCard
		card.default_icon = default_unit_icon

		_pool.add_child(card)
		card.call_deferred("setup", u)

		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.unit_selected.connect(_on_card_selected)
		_cards_by_unit[u.id] = card

	_refresh_pool_filter()
```
