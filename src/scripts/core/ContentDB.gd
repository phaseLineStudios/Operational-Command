extends Node
## Data loader and index for units, maps, briefs, and scenarios.
##
## Loads JSON assets from [code]res://data/[/code] and exposes typed accessors
## with basic validation and helpful error messages.

## Cache loaded objects by absolute path.
var _cache: Dictionary = {}

## Normalize to res:// and remove trailing slash.
func _norm_dir(dir_path: String) -> String:
	var p := dir_path
	if not p.begins_with("res://data/"):
		p = "res://data/" + p
	if p.ends_with("/"):
		p = p.substr(0, p.length() - 1)
	return p

## Recursively convert special string literals to engine types (minimal).
func _postprocess(v: Variant) -> Variant:
	match typeof(v):
		TYPE_DICTIONARY:
			var d := v as Dictionary
			for k in d.keys():
				d[k] = _postprocess(d[k])
			return d
		TYPE_ARRAY:
			var a := v as Array
			for i in a.size():
				a[i] = _postprocess(a[i])
			return a
		TYPE_STRING:
			var s := String(v).strip_edges()
			if s.begins_with("Vector2(") and s.ends_with(")"):
				var inner := s.substr(8, s.length() - 9)
				var parts := inner.split(",", false)
				if parts.size() == 2:
					var x := parts[0].strip_edges().to_float()
					var y := parts[1].strip_edges().to_float()
					return Vector2(x, y)
			return v
		_:
			return v

## Load a JSON file to Dictionary. Uses cache.
func _load_json(abs_path: String) -> Dictionary:
	if _cache.has(abs_path):
		return _cache[abs_path]
	if not FileAccess.file_exists(abs_path):
		return {}
	var txt := FileAccess.get_file_as_string(abs_path)
	var parsed: Variant = JSON.parse_string(txt)
	if parsed == null:
		push_warning("JSON parse failed: %s" % abs_path)
		return {}
	var cooked: Variant = _postprocess(parsed)
	if typeof(cooked) != TYPE_DICTIONARY:
		push_warning("Top-level JSON is not an object: %s" % abs_path)
		return {}
	_cache[abs_path] = cooked
	return cooked

## Get absolute file path for id in a directory.
func _resolve_id_path(dir_abs: String, id: String) -> String:
	var candidate := "%s/%s.json" % [dir_abs, id]
	return candidate if FileAccess.file_exists(candidate) else ""

## Read all objects in a directory.
func get_all_objects(dir_path: String) -> Array:
	var dir_abs := _norm_dir(dir_path)
	var out: Array = []
	var files := DirAccess.get_files_at(dir_abs)
	if files.is_empty():
		return out
	for f in files:
		if f.get_extension().to_lower() != "json":
			continue
		var path := "%s/%s" % [dir_abs, f]
		var obj := _load_json(path)
		if not obj.is_empty():
			out.append(obj)
	return out

## Read a single object by id.
func get_object(dir_path: String, id: String) -> Dictionary:
	var dir_abs := _norm_dir(dir_path)
	var path := _resolve_id_path(dir_abs, id)
	return {} if path == "" else _load_json(path)

## Read multiple objects by ids (keeps order).
func get_objects(dir_path: String, ids: Array) -> Array:
	var dir_abs := _norm_dir(dir_path)
	var out: Array = []
	out.resize(ids.size())
	for i in ids.size():
		var id_str := String(ids[i])
		var path := _resolve_id_path(dir_abs, id_str)
		out[i] = {} if path == "" else _load_json(path)
	return out

## Campaigns helpers.
func get_campaign(id: String) -> Dictionary:
	return get_object("campaigns", id)

func get_campaigns(ids: Array) -> Array:
	return get_objects("campaigns", ids)

func list_campaigns() -> Array:
	var camps := get_all_objects("campaigns")
	if camps.is_empty():
		return []

	# decorate with index to preserve stable order when orders are equal
	var decorated: Array = []
	var i := 0
	for c in camps:
		if c.is_empty():
			continue
		var ord := int(c.get("order", 2147483647)) # missing => bottom
		decorated.append([ord, i, c])
		i += 1

	decorated.sort_custom(func(a, b):
		return a[1] < b[1] if a[0] == b[0] else a[0] < b[0]
	)

	var out: Array = []
	for item in decorated:
		out.append(item[2])
	return out

## Missions helpers.
func get_mission(id: String) -> Dictionary:
	return get_object("missions", id)

func get_missions(ids: Array) -> Array:
	return get_objects("missions", ids)

func list_missions() -> Array:
	return get_all_objects("missions")
	
func list_missions_for_campaign(campaign_id: StringName) -> Array:
	var camp := get_campaign(campaign_id)
	if camp.is_empty():
		push_warning("Campaign not found: %s" % campaign_id)
		return []
	if not camp.has("missions") or typeof(camp["missions"]) != TYPE_ARRAY:
		push_warning("Campaign missing 'missions' array: %s" % campaign_id)
		return []

	var ids: Array = camp["missions"]
	var decorated: Array = []
	var i := 0
	for id_val in ids:
		var id_str := String(id_val)
		var m := get_mission(id_str)
		var ord := 2147483647
		if not m.is_empty():
			ord = int(m.get("order", ord))
		else:
			push_warning("Mission not found for id: %s" % id_str)
			m = {}
		decorated.append([ord, i, m])
		i += 1

	decorated.sort_custom(func(a, b):
		return a[1] < b[1] if a[0] == b[0] else a[0] < b[0]
	)

	var out: Array = []
	for item in decorated:
		out.append(item[2])
	return out

## Briefing helpers.
## Get a briefing by id OR by mission id (smart resolver).
func get_briefing(id_or_mission_id: String) -> Dictionary:
	var brief := get_object("briefs", id_or_mission_id)
	if not brief.is_empty():
		return brief

	var m := get_mission(id_or_mission_id)
	if m.is_empty():
		return {}

	var link_id := ""
	if m.has("briefing"):
		link_id = String(m["briefing"])
	if link_id != "":
		brief = get_object("briefs", link_id)
		if not brief.is_empty():
			return brief

	if m.has("briefing") and typeof(m["briefing"]) == TYPE_DICTIONARY:
		return m["briefing"]

	return {}

## Get multiple briefings by ids (keeps order).
func get_briefings(ids: Array) -> Array:
	return get_objects("briefs", ids)

## List all briefings.
func list_briefings() -> Array:
	return get_all_objects("briefs")

## Convenience explicit mission briefing resolver.
func get_briefing_for_mission(mission_id: String) -> Dictionary:
	return get_briefing(mission_id)

## Units helpers.
func get_unit(id: String) -> Dictionary:
	return get_object("units", id)

func get_units(ids: Array) -> Array:
	return get_objects("units", ids)

func list_units() -> Array:
	return get_all_objects("units")

func list_recruitable_units(mission_id: String):
	var mission := get_mission(mission_id)
	if mission.is_empty():
		push_warning("Mission not found: %s" % mission_id)
		return []
	if not mission.has("recruitable_units") or typeof(mission["recruitable_units"]) != TYPE_ARRAY:
		push_warning("Mission missing 'recruitable_units' array: %s" % mission_id)
		return []
	var ids: Array = mission["recruitable_units"]
	var out: Array = []
	for id in ids:
		var u := get_unit(String(id))
		if u.is_empty():
			push_warning("Unit not found for id: %s" % id)
			continue
		out.append(u)
	return out
