# FuelTest::_on_panel_done Function Reference

*Defined at:* `scripts/test/FuelTest.gd` (lines 300–304)</br>
*Belongs to:* [FuelTest](../../FuelTest.md)

**Signature**

```gdscript
func _on_panel_done(_plan: Dictionary, depot_after: float) -> void
```

## Source

```gdscript
func _on_panel_done(_plan: Dictionary, depot_after: float) -> void:
	depot_stock = depot_after
	_update_labels()
```
