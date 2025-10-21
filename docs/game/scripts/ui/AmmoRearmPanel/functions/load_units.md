# AmmoRearmPanel::load_units Function Reference

*Defined at:* `scripts/ui/AmmoRearmPanel.gd` (lines 34–44)</br>
*Belongs to:* [AmmoRearmPanel](../../AmmoRearmPanel.md)

**Signature**

```gdscript
func load_units(units: Array, depot_stock: Dictionary) -> void
```

## Source

```gdscript
func load_units(units: Array, depot_stock: Dictionary) -> void:
	var typed: Array[UnitData] = []
	for e in units:
		if e is UnitData:
			typed.append(e as UnitData)
	_units = typed
	_depot = depot_stock.duplicate(true)
	_refresh_units()
	_update_depot_label()
```
