# UnitPlaceTool::_is_already_used Function Reference

*Defined at:* `scripts/editors/tools/ScenarioUnitTool.gd` (lines 126–131)</br>
*Belongs to:* [UnitPlaceTool](../UnitPlaceTool.md)

**Signature**

```gdscript
func _is_already_used(ctx: ScenarioEditorContext, u: UnitData) -> bool
```

## Source

```gdscript
func _is_already_used(ctx: ScenarioEditorContext, u: UnitData) -> bool:
	if ctx.data and ctx.data.units:
		for su: ScenarioUnit in ctx.data.units:
			if su and su.unit and String(su.unit.id) == String(u.id):
				return true
	return false
```
