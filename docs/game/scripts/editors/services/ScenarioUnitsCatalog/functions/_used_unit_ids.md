# ScenarioUnitsCatalog::_used_unit_ids Function Reference

*Defined at:* `scripts/editors/services/ScenarioUnitsCatalog.gd` (lines 190–198)</br>
*Belongs to:* [ScenarioUnitsCatalog](../../ScenarioUnitsCatalog.md)

**Signature**

```gdscript
func _used_unit_ids(ctx: ScenarioEditorContext) -> Dictionary
```

## Source

```gdscript
func _used_unit_ids(ctx: ScenarioEditorContext) -> Dictionary:
	var used := {}
	if ctx.data and ctx.data.units:
		for su: ScenarioUnit in ctx.data.units:
			if su and su.unit:
				used[String(su.unit.id)] = true
	return used
```
