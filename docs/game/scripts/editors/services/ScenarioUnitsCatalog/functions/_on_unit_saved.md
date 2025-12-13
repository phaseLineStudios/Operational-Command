# ScenarioUnitsCatalog::_on_unit_saved Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 163–171)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _on_unit_saved(ctx: ScenarioEditorContext, unit: UnitData, _path: String) -> void
```

## Source

```gdscript
func _on_unit_saved(ctx: ScenarioEditorContext, unit: UnitData, _path: String) -> void:
	ContentDB.save_unit(unit)
	# Reload the unit list from ContentDB to pick up the new/edited unit
	all_units = ContentDB.list_units()
	_refresh(ctx)
	# Deselect after saving so user can select another unit
	_deselect_unit(ctx)
```
