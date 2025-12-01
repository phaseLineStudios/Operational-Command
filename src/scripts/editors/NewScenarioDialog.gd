class_name NewScenarioDialog
extends Window

## Emitted when user confirms new.
signal request_create(scenario_data: ScenarioData)
## Emitted when user confirms edit.
signal request_update(scenario_data: ScenarioData)

enum DialogMode { CREATE, EDIT }

var terrain: TerrainData
var thumbnail: Texture2D
var video_stream: VideoStream
var subtitle_track: SubtitleTrack
var dialog_mode: DialogMode = DialogMode.CREATE
var working: ScenarioData

var _all_units: Array[UnitData] = []
var _unit_by_id: Dictionary = {}
var _selected_units: Array[UnitData] = []

@onready var id_input: LineEdit = %Id
@onready var title_input: LineEdit = %Title
@onready var desc_input: TextEdit = %Description
@onready var thumb_preview: TextureRect = %ThumbnailPreview
@onready var thumb_path: LineEdit = %ThumbnailPath
@onready var thumb_btn: Button = %SelectThumbnail
@onready var thumb_clear: Button = %ClearThumbnail
@onready var terrain_path: LineEdit = %TerrainPath
@onready var terrain_btn: Button = %SelectTerrain
@onready var video_path: LineEdit = %VideoPath
@onready var video_btn: Button = %SelectVideo
@onready var video_clear: Button = %ClearVideo
@onready var subtitles_path: LineEdit = %SubtitlesPath
@onready var subtitles_btn: Button = %SelectSubtitles
@onready var subtitles_clear: Button = %ClearSubtitles
@onready var close_btn: Button = %Close
@onready var create_btn: Button = %Create
@onready var unit_pool: ItemList = %UnitPoolList
@onready var unit_selected: ItemList = %UnitSelectedList
@onready var unit_add: Button = %UnitAdd
@onready var unit_remove: Button = %UnitRemove

@onready var replacement_pool_spin: SpinBox = %ReplacementPool
@onready var equipment_pool_spin: SpinBox = %EquipmentPool
@onready var small_arms_spin: SpinBox = %SmallArms
@onready var tank_gun_spin: SpinBox = %TankGun
@onready var atgm_spin: SpinBox = %ATGM
@onready var at_rocket_spin: SpinBox = %ATRocket
@onready var heavy_weapons_spin: SpinBox = %HeavyWeapons
@onready var autocannon_spin: SpinBox = %Autocannon
@onready var mortar_ap_spin: SpinBox = %MortarAP
@onready var mortar_smoke_spin: SpinBox = %MortarSmoke
@onready var mortar_illum_spin: SpinBox = %MortarIllum
@onready var artillery_ap_spin: SpinBox = %ArtilleryAP
@onready var artillery_smoke_spin: SpinBox = %ArtillerySmoke
@onready var artillery_illum_spin: SpinBox = %ArtilleryIllum
@onready var engineer_mun_spin: SpinBox = %EngineerMun


func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	terrain_btn.pressed.connect(_on_terrain_select)
	thumb_btn.pressed.connect(_on_thumbnail_select)
	thumb_clear.pressed.connect(_on_thumbnail_clear)
	video_btn.pressed.connect(_on_video_select)
	video_clear.pressed.connect(_on_video_clear)
	subtitles_btn.pressed.connect(_on_subtitles_select)
	subtitles_clear.pressed.connect(_on_subtitles_clear)

	unit_add.pressed.connect(_on_unit_add_pressed)
	unit_remove.pressed.connect(_on_unit_remove_pressed)
	_load_units_pool()
	_refresh_unit_lists()


func _on_primary_pressed() -> void:
	match dialog_mode:
		DialogMode.CREATE:
			if not terrain:
				push_warning("No terrain selected")
				return
			var sd := ScenarioData.new()
			sd.id = id_input.text
			sd.title = title_input.text
			sd.description = desc_input.text
			sd.preview = thumbnail
			sd.terrain = terrain
			sd.video_path = video_path.text
			sd.video_subtitles_path = subtitles_path.text
			sd.unit_recruits = _selected_units.duplicate()
			_apply_pools_to_scenario(sd)
			emit_signal("request_create", sd)
		DialogMode.EDIT:
			if not working:
				push_warning("No scenario to update")
				return
			working.id = id_input.text
			working.title = title_input.text
			working.description = desc_input.text
			working.preview = thumbnail
			working.terrain = terrain
			working.video_path = video_path.text
			working.video_subtitles_path = subtitles_path.text
			working.unit_recruits = _selected_units.duplicate()
			_apply_pools_to_scenario(working)
			emit_signal("request_update", working)
	show_dialog(false)


func _on_terrain_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.json, *.json ; TerrainData")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var f := FileAccess.open(path, FileAccess.READ)
			if f == null:
				return false
			var text := f.get_as_text()
			f.close()
			var parsed: Variant = JSON.parse_string(text)
			if typeof(parsed) != TYPE_DICTIONARY:
				return false
			var dta := TerrainData.deserialize(parsed)
			if dta != null:
				terrain = dta
				terrain_path.text = path
			else:
				push_error("Not a TerrainData: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())


func _on_thumbnail_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.png, *.jpg ; Images")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var res := Image.new()
			var err := res.load(path)
			if err == OK:
				var tex = ImageTexture.create_from_image(res)

				thumbnail = tex
				thumb_path.text = path
				thumb_preview.texture = tex
			else:
				push_error("Not an Image: %s" % path)
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())


func _on_thumbnail_clear() -> void:
	thumb_path.text = ""
	thumb_preview.texture = null
	thumbnail = null


func _on_video_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.ogv ; OGG Video")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			video_path.text = path
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())


func _on_video_clear() -> void:
	video_path.text = ""
	video_stream = null


func _on_subtitles_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres ; Subtitle Track Resource")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			subtitles_path.text = path
			dlg.queue_free()
	)
	dlg.canceled.connect(func(): dlg.queue_free())


func _on_subtitles_clear() -> void:
	subtitles_path.text = ""
	subtitle_track = null


## Reset values before popup (only when hiding)
func _reset_values() -> void:
	title_input.text = ""
	desc_input.text = ""
	terrain_path.text = ""
	thumb_path.text = ""
	thumb_preview.texture = null
	video_path.text = ""
	subtitles_path.text = ""
	thumbnail = null
	terrain = null
	video_stream = null
	subtitle_track = null
	working = null
	dialog_mode = DialogMode.CREATE
	_title_button_from_mode()
	_reset_pool_values()


## Preload fields from existing ScenarioData.
func _load_from_data(d: ScenarioData) -> void:
	id_input.text = d.id
	title_input.text = d.title
	desc_input.text = d.description
	thumbnail = d.preview
	thumb_preview.texture = thumbnail
	terrain = d.terrain
	if ResourceLoader.exists(terrain.resource_path):
		terrain_path.text = terrain.resource_path
	else:
		terrain_path.text = ""
	video_path.text = d.video_path if d.video_path else ""
	subtitles_path.text = d.video_subtitles_path if d.video_subtitles_path else ""
	_selected_units = []
	if d.unit_recruits:
		for u in d.unit_recruits:
			if u is UnitData:
				_selected_units.append(u)
	_refresh_unit_lists()
	_load_pools_from_scenario(d)


## Update window title and primary button text to reflect mode.
func _title_button_from_mode() -> void:
	if dialog_mode == DialogMode.CREATE:
		title = "New Scenario"
		create_btn.text = "Create"
	else:
		title = "Edit Scenario"
		create_btn.text = "Save"


## Show/hide dialog.
func show_dialog(state: bool, existing: ScenarioData = null) -> void:
	if not state:
		hide()
		_reset_values()
		return

	if existing:
		dialog_mode = DialogMode.EDIT
		working = existing
		_load_from_data(existing)
	else:
		dialog_mode = DialogMode.CREATE

	_title_button_from_mode()
	popup_centered_ratio(0.55)


## Load all units from ContentDB and build id map.
func _load_units_pool() -> void:
	_all_units = []
	_unit_by_id.clear()
	if typeof(ContentDB) == TYPE_NIL:
		push_warning("ContentDB singleton not found; pool is empty.")
		return
	var arr := []
	if ContentDB.has_method("list_units"):
		arr = ContentDB.list_units()
	elif ContentDB.has_method("get_all_units"):
		arr = ContentDB.get_all_units()
	for u in arr:
		if u is UnitData and String(u.id) != "":
			_all_units.append(u)
			_unit_by_id[String(u.id)] = u


## Refresh both ItemLists from state.
func _refresh_unit_lists() -> void:
	if not is_instance_valid(unit_pool) or not is_instance_valid(unit_selected):
		return

	unit_pool.clear()
	unit_selected.clear()

	# Build a quick selected id set
	var sel_ids := {}
	for u in _selected_units:
		sel_ids[String(u.id)] = true

	# Pool = all - selected
	for u in _all_units:
		var uid := String(u.id)
		if sel_ids.has(uid):
			continue
		var idx := unit_pool.add_item(_unit_line(u))
		unit_pool.set_item_metadata(idx, {"id": uid})
		if u.icon:
			var img := u.icon.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			unit_pool.set_item_icon(idx, ImageTexture.create_from_image(img))

	# Selected list
	for u in _selected_units:
		var uid := String(u.id)
		var idx := unit_selected.add_item(_unit_line(u))
		unit_selected.set_item_metadata(idx, {"id": uid})
		if u.icon:
			var img := u.icon.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			unit_selected.set_item_icon(idx, ImageTexture.create_from_image(img))


## Compose a display line.
static func _unit_line(u: UnitData) -> String:
	return u.title


## Add by ItemList selection (pool -> selected).
func _on_unit_add_pressed() -> void:
	var items := unit_pool.get_selected_items()
	if items.is_empty():
		return
	var ids: Array[String] = []
	for i in items:
		var md: Variant = unit_pool.get_item_metadata(i)
		if typeof(md) == TYPE_DICTIONARY and md.has("id"):
			ids.append(String(md["id"]))
	_add_units_by_ids(ids)


## Remove by ItemList selection (selected -> pool).
func _on_unit_remove_pressed() -> void:
	var items := unit_selected.get_selected_items()
	if items.is_empty():
		return
	var ids: Array[String] = []
	for i in items:
		var md: Variant = unit_selected.get_item_metadata(i)
		if typeof(md) == TYPE_DICTIONARY and md.has("id"):
			ids.append(String(md["id"]))
	_remove_units_by_ids(ids)


## Drag & drop callback from UnitDDItemList.
## [param from_kind] UnitDDItemList.Kind
## [param to_kind] UnitDDItemList.Kind
func _on_unit_dropped(from_kind: int, to_kind: int, unit_id: String) -> void:
	if unit_id == "":
		return
	if from_kind == to_kind:
		return
	if to_kind == 1:  # SELECTED
		_add_units_by_ids([unit_id])
	else:  # POOL
		_remove_units_by_ids([unit_id])


## Append units by ids (dedup).
func _add_units_by_ids(ids: Array[String]) -> void:
	var need_refresh := false
	for id in ids:
		if not _unit_by_id.has(id):
			continue
		var u: UnitData = _unit_by_id[id]
		var already := false
		for ex in _selected_units:
			if String(ex.id) == id:
				already = true
				break
		if not already:
			_selected_units.append(u)
			need_refresh = true
	if need_refresh:
		_refresh_unit_lists()


## Remove units by ids.
func _remove_units_by_ids(ids: Array[String]) -> void:
	if ids.is_empty():
		return
	var need_refresh := false
	var keep: Array[UnitData] = []
	for u in _selected_units:
		if String(u.id) in ids:
			need_refresh = true
			continue
		keep.append(u)
	_selected_units = keep
	if need_refresh:
		_refresh_unit_lists()


## Apply pool values from UI to ScenarioData.
func _apply_pools_to_scenario(sd: ScenarioData) -> void:
	sd.replacement_pool = int(replacement_pool_spin.value)
	sd.equipment_pool = int(equipment_pool_spin.value)

	sd.ammo_pools = {}
	if small_arms_spin.value > 0:
		sd.ammo_pools["SMALL_ARMS"] = int(small_arms_spin.value)
	if tank_gun_spin.value > 0:
		sd.ammo_pools["TANK_GUN"] = int(tank_gun_spin.value)
	if atgm_spin.value > 0:
		sd.ammo_pools["ATGM"] = int(atgm_spin.value)
	if at_rocket_spin.value > 0:
		sd.ammo_pools["AT_ROCKET"] = int(at_rocket_spin.value)
	if heavy_weapons_spin.value > 0:
		sd.ammo_pools["HEAVY_WEAPONS"] = int(heavy_weapons_spin.value)
	if autocannon_spin.value > 0:
		sd.ammo_pools["AUTOCANNON"] = int(autocannon_spin.value)
	if mortar_ap_spin.value > 0:
		sd.ammo_pools["MORTAR_AP"] = int(mortar_ap_spin.value)
	if mortar_smoke_spin.value > 0:
		sd.ammo_pools["MORTAR_SMOKE"] = int(mortar_smoke_spin.value)
	if mortar_illum_spin.value > 0:
		sd.ammo_pools["MORTAR_ILLUM"] = int(mortar_illum_spin.value)
	if artillery_ap_spin.value > 0:
		sd.ammo_pools["ARTILLERY_AP"] = int(artillery_ap_spin.value)
	if artillery_smoke_spin.value > 0:
		sd.ammo_pools["ARTILLERY_SMOKE"] = int(artillery_smoke_spin.value)
	if artillery_illum_spin.value > 0:
		sd.ammo_pools["ARTILLERY_ILLUM"] = int(artillery_illum_spin.value)
	if engineer_mun_spin.value > 0:
		sd.ammo_pools["ENGINEER_MUN"] = int(engineer_mun_spin.value)


## Load pool values from ScenarioData to UI.
func _load_pools_from_scenario(d: ScenarioData) -> void:
	replacement_pool_spin.value = float(d.replacement_pool)
	equipment_pool_spin.value = float(d.equipment_pool)

	small_arms_spin.value = float(d.ammo_pools.get("SMALL_ARMS", 0))
	tank_gun_spin.value = float(d.ammo_pools.get("TANK_GUN", 0))
	atgm_spin.value = float(d.ammo_pools.get("ATGM", 0))
	at_rocket_spin.value = float(d.ammo_pools.get("AT_ROCKET", 0))
	heavy_weapons_spin.value = float(d.ammo_pools.get("HEAVY_WEAPONS", 0))
	autocannon_spin.value = float(d.ammo_pools.get("AUTOCANNON", 0))
	mortar_ap_spin.value = float(d.ammo_pools.get("MORTAR_AP", 0))
	mortar_smoke_spin.value = float(d.ammo_pools.get("MORTAR_SMOKE", 0))
	mortar_illum_spin.value = float(d.ammo_pools.get("MORTAR_ILLUM", 0))
	artillery_ap_spin.value = float(d.ammo_pools.get("ARTILLERY_AP", 0))
	artillery_smoke_spin.value = float(d.ammo_pools.get("ARTILLERY_SMOKE", 0))
	artillery_illum_spin.value = float(d.ammo_pools.get("ARTILLERY_ILLUM", 0))
	engineer_mun_spin.value = float(d.ammo_pools.get("ENGINEER_MUN", 0))


## Reset pool values to defaults.
func _reset_pool_values() -> void:
	replacement_pool_spin.value = 0.0
	equipment_pool_spin.value = 100.0
	small_arms_spin.value = 0.0
	tank_gun_spin.value = 0.0
	atgm_spin.value = 0.0
	at_rocket_spin.value = 0.0
	heavy_weapons_spin.value = 0.0
	autocannon_spin.value = 0.0
	mortar_ap_spin.value = 0.0
	mortar_smoke_spin.value = 0.0
	mortar_illum_spin.value = 0.0
	artillery_ap_spin.value = 0.0
	artillery_smoke_spin.value = 0.0
	artillery_illum_spin.value = 0.0
	engineer_mun_spin.value = 0.0
