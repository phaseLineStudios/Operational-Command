# ScenarioUnitsCatalog::_get_selected_unit Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 159–169)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _get_selected_unit(ctx: ScenarioEditorContext) -> UnitData
```

## Description

Get the UnitData from the current selection.

## Source

```gdscript
func _get_selected_unit(ctx: ScenarioEditorContext) -> UnitData:
	var it := ctx.unit_list.get_selected()
	if it == null:
		return
	var payload: Variant = it.get_metadata(0)
	if payload is UnitData:
		return payload

	return null
```
