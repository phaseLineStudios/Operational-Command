extends RefCounted
class_name ScenarioPersistenceService

const JSON_FILTER: PackedStringArray= ["*.json ; Scenario JSON"]

func suggest_filename(ctx: ScenarioEditorContext) -> String:
	var base := (ctx.data.title if ctx.data and String(ctx.data.title) != "" else "scenario")
	base = base.strip_edges().to_lower().replace(" ", "_")
	return ensure_json_ext(base)

func ensure_json_ext(p: String) -> String:
	return p if p.to_lower().ends_with(".json") else "%s.json" % p

func save_to_path(ctx: ScenarioEditorContext, path: String) -> bool:
	if ctx.data == null: return false
	var out_dict := ctx.data.serialize()
	var json_text := JSON.stringify(out_dict, "  ")
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null: return false
	f.store_string(json_text)
	f.flush()
	f.close()
	return true

func load_from_path(ctx: ScenarioEditorContext, path: String) -> bool:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null: return false
	var text := f.get_as_text()
	f.close()
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var data := ScenarioData.deserialize(parsed)
	ctx.data = data
	return true
