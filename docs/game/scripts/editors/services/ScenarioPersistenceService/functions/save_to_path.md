# ScenarioPersistenceService::save_to_path Function Reference

*Defined at:* `scripts/editors/services/ScenarioPersistenceService.gd` (lines 17–30)</br>
*Belongs to:* [ScenarioPersistenceService](../../ScenarioPersistenceService.md)

**Signature**

```gdscript
func save_to_path(ctx: ScenarioEditorContext, path: String) -> bool
```

## Source

```gdscript
func save_to_path(ctx: ScenarioEditorContext, path: String) -> bool:
	if ctx.data == null:
		return false
	var out_dict := ctx.data.serialize()
	var json_text := JSON.stringify(out_dict, "  ")
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(json_text)
	f.flush()
	f.close()
	return true
```
