# MilSymbolTest::_refresh_options Function Reference

*Defined at:* `scripts/test/MilSymbolTest.gd` (lines 147–183)</br>
*Belongs to:* [MilSymbolTest](../../MilSymbolTest.md)

**Signature**

```gdscript
func _refresh_options() -> void
```

## Description

Refreshes option buttons.

## Source

```gdscript
func _refresh_options() -> void:
	var u_type_val := u_type.selected
	var u_size_val := u_size.selected
	var u_modifier_1_val := u_modifier_1.selected
	var u_modifier_2_val := u_modifier_2.selected
	var u_status_val := u_status.selected
	var u_reinforced_reduced_val := u_reinforced_reduced.selected

	u_type.clear()
	for type_str in MilSymbol.UnitType.keys():
		u_type.add_item(type_str)
	u_type.select(u_type_val if u_type_val > -1 else u_type.item_count - 1)

	u_size.clear()
	for size_str in MilSymbol.UnitSize.keys():
		u_size.add_item(size_str)
	u_size.select(u_size_val if u_size_val > -1 else u_size.item_count - 1)

	u_modifier_1.clear()
	for mod1_str in MilSymbol.Modifier1.keys():
		u_modifier_1.add_item(mod1_str)
	u_modifier_1.select(u_modifier_1_val if u_modifier_1_val > -1 else 0)

	u_modifier_2.clear()
	for mod2_str in MilSymbol.Modifier2.keys():
		u_modifier_2.add_item(mod2_str)
	u_modifier_2.select(u_modifier_2_val if u_modifier_2_val > -1 else 0)

	u_status.clear()
	for status_str in MilSymbol.UnitStatus.keys():
		u_status.add_item(status_str)
	u_status.select(u_status_val if u_status_val > -1 else 0)

	u_reinforced_reduced.clear()
	for rf_rd_str in MilSymbol.UnitReinforcedReduced.keys():
		u_reinforced_reduced.add_item(rf_rd_str)
	u_reinforced_reduced.select(u_reinforced_reduced_val if u_reinforced_reduced_val > -1 else 0)
```
