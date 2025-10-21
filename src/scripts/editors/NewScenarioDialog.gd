class_name NewScenarioDialog
extends Window

## Emitted when user confirms new.
signal request_create(scenario_data: ScenarioData)
## Emitted when user confirms edit.
signal request_update(scenario_data: ScenarioData)

enum DialogMode { CREATE, EDIT }

var terrain: TerrainData
var thumbnail: Texture2D
var dialog_mode: DialogMode = DialogMode.CREATE
var working: ScenarioData

var _all_units: Array[UnitData] = []
var _unit_by_id: Dictionary = {}
var _selected_units: Array[UnitData] = []

@onready var title_input: LineEdit = %Title
@onready var desc_input: TextEdit = %Description
@onready var thumb_preview: TextureRect = %ThumbnailPreview
@onready var thumb_path: LineEdit = %ThumbnailPath
@onready var thumb_btn: Button = %SelectThumbnail
@onready var thumb_clear: Button = %ClearThumbnail
@onready var terrain_path: LineEdit = %TerrainPath
@onready var terrain_btn: Button = %SelectTerrain
@onready var close_btn: Button = %Close
@onready var create_btn: Button = %Create
@onready var unit_pool: ItemList = %UnitPoolList
@onready var unit_selected: ItemList = %UnitSelectedList
@onready var unit_add: Button = %UnitAdd
@onready var unit_remove: Button = %UnitRemove


func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	terrain_btn.pressed.connect(_on_terrain_select)
	thumb_btn.pressed.connect(_on_thumbnail_select)
	thumb_clear.pressed.connect(_on_thumbnail_clear)
	
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
			sd.title = title_input.text
			sd.description = desc_input.text
			sd.preview = thumbnail
			sd.terrain = terrain
			sd.unit_recruits = _selected_units.duplicate() 
			emit_signal("request_create", sd)
		DialogMode.EDIT:
			if not working:
				push_warning("No scenario to update")
				return
			working.title = title_input.text
			working.description = desc_input.text
			working.preview = thumbnail
			working.terrain = terrain
			working.unit_recruits = _selected_units.duplicate() 
			emit_signal("request_update", working)
	show_dialog(false)


func _on_terrain_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres, *.res ; TerrainData")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(
		func(path):
			var res := ResourceLoader.load(path)
			if res is TerrainData:
				terrain = res
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


## Reset values before popup (only when hiding)
func _reset_values() -> void:
	title_input.text = ""
	desc_input.text = ""
	terrain_path.text = ""
	thumb_path.text = ""
	thumb_preview.texture = null
	thumbnail = null
	terrain = null
	working = null
	dialog_mode = DialogMode.CREATE
	_title_button_from_mode()


## Preload fields from existing ScenarioData.
func _load_from_data(d: ScenarioData) -> void:
	title_input.text = d.title
	desc_input.text = d.description
	thumbnail = d.preview
	thumb_preview.texture = thumbnail
	terrain = d.terrain
	if ResourceLoader.exists(terrain.resource_path):
		terrain_path.text = terrain.resource_path
	else:
		terrain_path.text = ""


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
	if to_kind == 1: # SELECTED
		_add_units_by_ids([unit_id])
	else: # POOL
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
