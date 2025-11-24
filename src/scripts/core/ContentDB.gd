extends Node
## Data loader and index for units, maps, briefs, and scenarios.
##
## Loads JSON assets from [code]res://data/[/code] and exposes typed accessors
## with basic validation and helpful error messages.

## Cache loaded objects by absolute path.
const AMMO_DAMAGE_CONFIG: AmmoDamageConfig = preload("res://assets/configs/ammo_damage_config.tres")
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
	var files := ResourceLoader.list_directory(dir_abs)
	for file in files:
		var is_dir := file[file.length() - 1] == "/"
		var extension := file.split(".")[-1]
		if not is_dir and extension in ["json"]:
			var path := "%s/%s" % [dir_abs, file]
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
## Get Campaign by ID
func get_campaign(id: String) -> CampaignData:
	var d := get_object("campaigns", id)
	if d.is_empty():
		push_warning("Campaign not found: %s" % id)
		return null
	return CampaignData.deserialize(d)


## Get multiple campaigns by IDs
func get_campaigns(ids: Array) -> Array:
	var out: Array[CampaignData] = []
	for raw in ids:
		var s := get_campaign(String(raw))
		if s:
			out.append(s)
	return out


## List all campaigns
func list_campaigns() -> Array:
	var camps := get_all_objects("campaigns")
	if camps.is_empty():
		return []

	var decorated: Array = []
	var i := 0
	for c in camps:
		if c.is_empty():
			continue
		var order := int(c.get("order", 2147483647))  # missing => bottom
		decorated.append([order, i, c])
		i += 1

	decorated.sort_custom(func(a, b): return a[1] < b[1] if a[0] == b[0] else a[0] < b[0])

	var out: Array[CampaignData] = []
	for item in decorated:
		var d: Dictionary = item[2]
		var res := CampaignData.deserialize(d)
		if res != null:
			out.append(res)
	return out


## Missions helpers.
## Get Mission by ID
func get_scenario(id: String) -> ScenarioData:
	var d := get_object("scenarios", id)
	if d.is_empty():
		push_warning("Mission not found: %s" % id)
		return null
	return ScenarioData.deserialize(d)


## Get multiple scenarios by IDs
func get_scenarios(ids: Array) -> Array[ScenarioData]:
	var out: Array[ScenarioData] = []
	for raw in ids:
		var s := get_scenario(String(raw))
		if s:
			out.append(s)
	return out


## list all scenarios
func list_scenarios() -> Array[ScenarioData]:
	var camps := get_all_objects("scenarios")
	if camps.is_empty():
		return []

	var out: Array[ScenarioData] = []
	for item in camps:
		var res := ScenarioData.deserialize(item)
		if res != null:
			out.append(res)
	return out


## Terrain helpers.
## Get Terrain by ID.
## [param id] Terrain ID.
## [return] Associated Terrain Data.
func get_terrain(id: String) -> TerrainData:
	var d := get_object("terrains", id)
	if d.is_empty():
		push_warning("Terrain not found: %s" % id)
		return null
	return TerrainData.deserialize(d)


## Get multiple terrains by IDs.
## [param ids] Array of ids to fetch.
## [return] Array of associated Terrain Data.
func get_terrains(ids: Array) -> Array[TerrainData]:
	var out: Array[TerrainData] = []
	for raw in ids:
		var s := get_terrain(String(raw))
		if s:
			out.append(s)
	return out


## list all terrains.
## [return] Array of all terrains.
func list_terrains() -> Array[TerrainData]:
	var terrs := get_all_objects("terrains")
	if terrs.is_empty():
		return []

	var out: Array[TerrainData] = []
	for item in terrs:
		var res := TerrainData.deserialize(item)
		if res != null:
			out.append(res)
	return out


## List all scenarios for a campaign by ID
func list_scenarios_for_campaign(campaign_id: StringName) -> Array[ScenarioData]:
	var camp := get_object("campaigns", String(campaign_id))
	if camp.is_empty():
		push_warning("Campaign not found: %s" % campaign_id)
		return []

	var ids: Array = []
	if typeof(camp["scenarios"]) == TYPE_ARRAY:
		ids = camp["scenarios"]
	else:
		push_warning("Campaign missing 'scenarios' array: %s" % campaign_id)
		return []

	var decorated: Array = []
	var i := 0
	for id_val in ids:
		var id_str := String(id_val)
		var m_dict := get_object("scenarios", id_str)
		var order := 2147483647
		if not m_dict.is_empty():
			if m_dict.has("order"):
				order = int(m_dict["order"])
			elif m_dict.has("scenario_order"):
				order = int(m_dict["scenario_order"])
		else:
			push_warning("Scenario not found for id: %s" % id_str)
		decorated.append([order, i, id_str])
		i += 1

	decorated.sort_custom(func(a, b): return a[1] < b[1] if a[0] == b[0] else a[0] < b[0])

	var out: Array[ScenarioData] = []
	for item in decorated:
		var mid := String(item[2])
		var m_res := get_scenario(mid)
		if m_res != null:
			out.append(m_res)
	return out


## Briefing helpers.
## Get a briefing by id or by mission id
func get_briefing(id_or_mission_id: String) -> BriefData:
	var brief_d := get_object("briefs", id_or_mission_id)
	if brief_d.is_empty():
		var m_json := get_object("scenarios", id_or_mission_id)
		if m_json.is_empty():
			return null
		var link_id := ""
		if m_json.has("briefing"):
			link_id = String(m_json["briefing"])
		if link_id != "":
			brief_d = get_object("briefs", link_id)
			if brief_d.is_empty():
				return null
		elif m_json.has("briefing") and typeof(m_json["briefing"]) == TYPE_DICTIONARY:
			brief_d = m_json["briefing"]
			if typeof(brief_d) != TYPE_DICTIONARY:
				return null
	return BriefData.deserialize(brief_d)


## Get multiple briefings by ids
func get_briefings(ids: Array) -> Array[BriefData]:
	var out: Array[BriefData] = []
	for raw in ids:
		var u: BriefData = get_briefing(String(raw))
		if u != null:
			out.append(u)
	return out


## List all briefings
func list_briefings() -> Array[BriefData]:
	var camps := get_all_objects("briefs")
	if camps.is_empty():
		return []

	var out: Array[BriefData] = []
	for item in camps:
		var res := BriefData.deserialize(item)
		if res != null:
			out.append(res)
	return out


## Convenience explicit mission briefing resolver.
func get_briefing_for_mission(mission_id: String) -> BriefData:
	return get_briefing(mission_id)


## Units helpers.
## Get unit by ID
func get_unit(id: String) -> UnitData:
	var d := get_object("units", id)
	if d.is_empty():
		push_warning("Unit not found: %s" % id)
		return null
	var u := UnitData.deserialize(d)
	if u:
		u.compute_attack_power(AMMO_DAMAGE_CONFIG)
	return u


## Get units by IDs
func get_units(ids: Array) -> Array[UnitData]:
	var out: Array[UnitData] = []
	for raw in ids:
		var u: UnitData = get_unit(String(raw))
		if u != null:
			out.append(u)
	return out


## List all units
func list_units() -> Array[UnitData]:
	var camps := get_all_objects("units")
	if camps.is_empty():
		return []

	var out: Array[UnitData] = []
	for item in camps:
		var res := UnitData.deserialize(item)
		if res != null:
			res.compute_attack_power(AMMO_DAMAGE_CONFIG)
			out.append(res)
	return out


## Save a UnitData to res://data/units/<id>.json and update cache.
## [param unit] UnitData to save.
## [return] Absolute path or "" on error.
func save_unit(unit: UnitData) -> String:
	if unit == null or String(unit.id).strip_edges() == "":
		push_warning("save_unit: missing unit or id")
		return ""
	var dir_abs := _norm_dir("units")
	var mk := DirAccess.make_dir_recursive_absolute(dir_abs)
	if mk != OK and mk != ERR_ALREADY_EXISTS:
		push_warning("save_unit: cannot create %s (err %d)" % [dir_abs, mk])
		return ""
	var abs_path := "%s/%s.json" % [dir_abs, unit.id]
	var f := FileAccess.open(abs_path, FileAccess.WRITE)
	if f == null:
		push_warning("save_unit: cannot open %s (err %d)" % [abs_path, FileAccess.get_open_error()])
		return ""
	var payload := unit.serialize().duplicate(true)
	f.store_string(JSON.stringify(payload, "  "))
	f.flush()
	f.close()
	_cache[abs_path] = payload
	return abs_path


## Unit Category helpers.
## Get unit category by ID
func get_unit_category(id: String) -> UnitCategoryData:
	var d := get_object("unit_categories", id)
	if d.is_empty():
		push_warning("Unit category not found: %s" % id)
		return null
	return UnitCategoryData.deserialize(d)


## Get unit categories by IDs
func get_unit_categories(ids: Array) -> Array[UnitCategoryData]:
	var out: Array[UnitCategoryData] = []
	for raw in ids:
		var u: UnitCategoryData = get_unit_category(String(raw))
		if u != null:
			out.append(u)
	return out


## List all unit categories
func list_unit_categories() -> Array[UnitCategoryData]:
	var camps := get_all_objects("unit_categories")
	if camps.is_empty():
		return []

	var out: Array[UnitCategoryData] = []
	for item in camps:
		var res := UnitCategoryData.deserialize(item)
		if res != null:
			out.append(res)
	return out


## Get list of reqreuitable units for scenario
func list_recruitable_units(mission_id: String) -> Array[UnitData]:
	var mission := get_object("scenarios", mission_id)
	if mission.is_empty():
		push_warning("Mission not found: %s" % mission_id)
		return []

	var ids: Array = []
	if mission.has("recruitable_units") and typeof(mission["recruitable_units"]) == TYPE_ARRAY:
		# legacy/simple schema
		ids = mission["recruitable_units"]
	elif mission.has("units") and typeof(mission["units"]) == TYPE_DICTIONARY:
		var um: Dictionary = mission["units"]
		if um.has("unit_recruits_ids") and typeof(um["unit_recruits_ids"]) == TYPE_ARRAY:
			# new schema produced by ScenarioData.serialize()
			ids = um["unit_recruits_ids"]
		else:
			push_warning("Mission 'units' present but missing 'unit_recruits_ids': %s" % mission_id)
	else:
		push_warning("Mission missing recruitable units list: %s" % mission_id)
		return []

	var out: Array[UnitData] = []
	for id_val in ids:
		var u := get_unit(String(id_val))
		if u != null:
			out.append(u)
		else:
			push_warning("Unit not found for id: %s" % String(id_val))
	return out


## Serialization helpers
## Serialize Vector2
func v2(v: Vector2) -> Dictionary:
	return {"x": v.x, "y": v.y}


## Deserialize Vector2
func v2_from(d: Variant) -> Vector2:
	if typeof(d) == TYPE_DICTIONARY and d.has("x") and d.has("y"):
		return Vector2(float(d["x"]), float(d["y"]))
	if typeof(d) == TYPE_ARRAY and d.size() >= 2:
		return Vector2(float(d[0]), float(d[1]))
	return Vector2.ZERO


## Serialize PackedVector2Array
func v2arr_serialize(a: PackedVector2Array) -> Array:
	var out: Array = []
	for p in a:
		out.append(v2(p))
	return out


## deserialize PackedVector2Array
func v2arr_deserialize(a: Variant) -> PackedVector2Array:
	var out := PackedVector2Array()
	if typeof(a) != TYPE_ARRAY:
		return out
	out.resize(a.size())
	for i in a.size():
		out[i] = v2_from(a[i])
	return out


## serialize a resource
func res_path_or_null(res: Variant) -> Variant:
	if typeof(res) == TYPE_STRING:
		var s := String(res)
		@warning_ignore("incompatible_ternary")
		return s if s != "" else null
	if res is Resource and String(res.resource_path) != "":
		return res.resource_path
	return null


## Deserialize a resource
func load_res(path: Variant) -> Variant:
	if typeof(path) == TYPE_STRING:
		var s := String(path)
		if s != "":
			return load(s)
	return null


## Serialize a image to Base 64
func image_to_png_b64(img: Image) -> String:
	if img == null or img.is_empty():
		return ""
	var png: PackedByteArray = img.save_png_to_buffer()
	return Marshalls.raw_to_base64(png)


## Deserialize a image from Base 64
func png_b64_to_image(b64: Variant) -> Image:
	if typeof(b64) != TYPE_STRING or String(b64) == "":
		return Image.new()
	var bytes: PackedByteArray = Marshalls.base64_to_raw(String(b64))
	var img := Image.new()
	var err := img.load_png_from_buffer(bytes)
	return img if err == OK else Image.new()


## Serialize a floating-point image to Base 64 (lossless raw format)
func image_to_raw_b64(img: Image) -> Dictionary:
	if img == null or img.is_empty():
		return {}
	# Store raw float data directly - more efficient than EXR for single-channel data
	var width := img.get_width()
	var height := img.get_height()
	var data := PackedFloat32Array()
	data.resize(width * height)

	var idx := 0
	for y in height:
		for x in width:
			data[idx] = img.get_pixel(x, y).r
			idx += 1

	return {
		"width": width,
		"height": height,
		"data": Marshalls.raw_to_base64(data.to_byte_array())
	}


## Deserialize a floating-point image from raw Base 64 format
func raw_b64_to_image(raw_dict: Variant) -> Image:
	if typeof(raw_dict) != TYPE_DICTIONARY:
		return Image.new()

	var width: int = raw_dict.get("width", 0)
	var height: int = raw_dict.get("height", 0)
	var b64: String = raw_dict.get("data", "")

	if width <= 0 or height <= 0 or b64 == "":
		return Image.new()

	var bytes := Marshalls.base64_to_raw(b64)
	var data := PackedFloat32Array()
	data.resize(width * height)

	# Convert bytes back to float array
	for i in data.size():
		var offset := i * 4  # 4 bytes per float32
		if offset + 3 < bytes.size():
			data[i] = bytes.decode_float(offset)

	# Create image and populate with float data
	var img := Image.create(width, height, false, Image.FORMAT_RF)
	var idx := 0
	for y in height:
		for x in width:
			img.set_pixel(x, y, Color(data[idx], 0, 0, 1))
			idx += 1

	return img


## Serialize resources to IDs
func ids_from_resources(arr: Array, id_prop: String = "id") -> Array:
	var out: Array = []
	for r in arr:
		if r != null and r.has_method("get"):
			var rid = r.get(id_prop)
			if rid != null and String(rid) != "":
				out.append(String(rid))
	return out


## Deserialize resources from IDs
func resources_from_ids(ids: Array, loader: Callable) -> Array:
	var out: Array = []
	if typeof(ids) != TYPE_ARRAY:
		return out
	for raw in ids:
		var id_str := String(raw)
		var res: Variant = loader.call(id_str)
		if res != null:
			out.append(res)
	return out


## Generate ID from string
## [param string] String to generate ID from.
func id_from_string(string: String) -> String:
	var cleaned := string.to_lower().replace(" ", "_")
	return cleaned


## Safely duplicate a dictionary or array
func safe_dup(v: Variant) -> Variant:
	match typeof(v):
		TYPE_DICTIONARY:
			return (v as Dictionary).duplicate(true)
		TYPE_ARRAY:
			return (v as Array).duplicate(true)
		_:
			return v
