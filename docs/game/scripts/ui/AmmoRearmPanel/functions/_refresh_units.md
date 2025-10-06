# AmmoRearmPanel::_refresh_units Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 58–68)</br>
*Belongs to:* [AmmoRearmPanel](../AmmoRearmPanel.md)

**Signature**

```gdscript
func _refresh_units() -> void
```

## Source

```gdscript
func _refresh_units() -> void:
	_lst_units.clear()
	for i in range(_units.size()):
		var u: UnitData = _units[i]
		_lst_units.add_item("%s (%s)" % [u.title, u.id])
		_lst_units.set_item_tooltip(i, _ammo_tooltip(u))
	_clear_children(_box_ammo)
	_sliders_ammo.clear()
	_sliders_stock.clear()
```
