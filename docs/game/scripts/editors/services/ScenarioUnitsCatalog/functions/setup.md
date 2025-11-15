# ScenarioUnitsCatalog::setup Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 10–19)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func setup(ctx: ScenarioEditorContext) -> void
```

## Source

```gdscript
func setup(ctx: ScenarioEditorContext) -> void:
	slot_proto.title = "Playable Slot"
	all_units = ContentDB.list_units()
	unit_categories = ContentDB.list_unit_categories()
	_build_categories(ctx)
	_setup_tree(ctx)
	_setup_unit_create(ctx)
	_refresh(ctx)
```
