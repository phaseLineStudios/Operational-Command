# NewScenarioDialog::_on_unit_dropped Function Reference

*Defined at:* `scripts/editors/NewScenarioDialog.gd` (lines 379–389)</br>
*Belongs to:* [NewScenarioDialog](../../NewScenarioDialog.md)

**Signature**

```gdscript
func _on_unit_dropped(from_kind: int, to_kind: int, unit_id: String) -> void
```

- **from_kind**: UnitDDItemList.Kind
- **to_kind**: UnitDDItemList.Kind

## Description

Drag & drop callback from UnitDDItemList.

## Source

```gdscript
func _on_unit_dropped(from_kind: int, to_kind: int, unit_id: String) -> void:
	if unit_id == "":
		return
	if from_kind == to_kind:
		return
	if to_kind == 1:  # SELECTED
		_add_units_by_ids([unit_id])
	else:  # POOL
		_remove_units_by_ids([unit_id])
```
