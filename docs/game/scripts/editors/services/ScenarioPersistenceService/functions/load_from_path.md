# ScenarioPersistenceService::load_from_path Function Reference

*Defined at:* `scripts/editors/services/ScenarioPersistenceService.gd` (lines 31–42)</br>
*Belongs to:* [ScenarioPersistenceService](../ScenarioPersistenceService.md)

**Signature**

```gdscript
func load_from_path(ctx: ScenarioEditorContext, path: String) -> bool
```

## Source

```gdscript
func load_from_path(ctx: ScenarioEditorContext, path: String) -> bool:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var text := f.get_as_text()
	f.close()
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var data := ScenarioData.deserialize(parsed)
	ctx.data = data
	return true
```
