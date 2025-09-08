extends Window
class_name NewScenarioDialog

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

var terrain: TerrainData
var thumbnail: Texture2D

## Request scenario create
signal request_create(scenario_data: ScenarioData)

func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	close_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))
	terrain_btn.pressed.connect(_on_terrain_select)
	thumb_btn.pressed.connect(_on_thumbnail_select)
	thumb_clear.pressed.connect(_on_thumbnail_clear)

func _on_primary_pressed() -> void:
	if not terrain:
		print("No terrain selected")
		return
	
	var data := ScenarioData.new()
	data.title = title_input.text
	data.description = desc_input.text
	data.preview_path = thumb_path.text
	data.terrain_path = terrain_path.text
	data.preview = thumbnail
	data.terrain = terrain
	emit_signal("request_create", data)
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
		if not err:
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

## Show/hide dialog
func show_dialog(state: bool) -> void:
	visible = state
	if not state:
		_reset_values()
