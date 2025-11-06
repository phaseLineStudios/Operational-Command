# ScenarioUnitsCatalog::_on_unit_saved Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 153–157)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _on_unit_saved(ctx: ScenarioEditorContext, unit: UnitData, _path: String) -> void
```

## Source

```gdscript
func _on_unit_saved(ctx: ScenarioEditorContext, unit: UnitData, _path: String) -> void:
	ContentDB.save_unit(unit)
	_refresh(ctx)
```
