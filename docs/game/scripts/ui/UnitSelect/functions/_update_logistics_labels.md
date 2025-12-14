# UnitSelect::_update_logistics_labels Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 367–373)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _update_logistics_labels(equipment: int, fuel: int, medical: int, repair: int) -> void
```

## Description

Update logistics labels with current totals

## Source

```gdscript
func _update_logistics_labels(equipment: int, fuel: int, medical: int, repair: int) -> void:
	_lbl_ammo.text = "Equipment: %d" % equipment
	_lbl_fuel.text = "Fuel: %d" % fuel
	_lbl_med.text = "Medical: %d" % medical
	_lbl_rep.text = "Repair: %d" % repair
```
