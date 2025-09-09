extends Window
class_name NewScenarioDialog

enum DialogMode { CREATE, EDIT }

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

## Emitted when user confirms new.
signal request_create(scenario_data: ScenarioData)
## Emitted when user confirms edit.
signal request_update(scenario_data: ScenarioData)

var terrain: TerrainData
var thumbnail: Texture2D

var dialog_mode: DialogMode = DialogMode.CREATE
var working: ScenarioData

func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	terrain_btn.pressed.connect(_on_terrain_select)
	thumb_btn.pressed.connect(_on_thumbnail_select)
	thumb_clear.pressed.connect(_on_thumbnail_clear)

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
			emit_signal("request_create", sd)
		DialogMode.EDIT:
			if not working:
				push_warning("No scenario to update")
				return
			working.title = title_input.text
			working.description = desc_input.text
			working.preview = thumbnail
			working.terrain = terrain
			emit_signal("request_update", working)
	show_dialog(false)

func _on_terrain_select() -> void:
	var dlg := FileDialog.new()
	dlg.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dlg.access = FileDialog.ACCESS_FILESYSTEM
	dlg.add_filter("*.tres, *.res ; TerrainData")
	add_child(dlg)
	dlg.popup_centered_ratio(0.5)
	dlg.file_selected.connect(func(path):
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
	dlg.file_selected.connect(func(path):
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
	pass

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
		visible = false
		_reset_values()
		return

	if existing:
		dialog_mode = DialogMode.EDIT
		working = existing
		_load_from_data(existing)
	else:
		dialog_mode = DialogMode.CREATE

	_title_button_from_mode()
	visible = true
