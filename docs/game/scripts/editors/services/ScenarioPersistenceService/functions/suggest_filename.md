# ScenarioPersistenceService::suggest_filename Function Reference

*Defined at:* `scripts/editors/services/ScenarioPersistenceService.gd` (lines 7–12)</br>
*Belongs to:* [ScenarioPersistenceService](../../ScenarioPersistenceService.md)

**Signature**

```gdscript
func suggest_filename(ctx: ScenarioEditorContext) -> String
```

## Source

```gdscript
func suggest_filename(ctx: ScenarioEditorContext) -> String:
	var base := ctx.data.title if ctx.data and String(ctx.data.title) != "" else "scenario"
	base = base.strip_edges().to_lower().replace(" ", "_")
	return ensure_json_ext(base)
```
