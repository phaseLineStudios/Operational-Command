class_name NewTerrainDialog
extends Window

## Request terrain create
signal request_create(terrain_data)
## Request terrain edit
signal request_edit(terrain_data)

var editor: TerrainEditor
var _is_edit_mode := false
var _target_data: TerrainData = null

@onready var terrain_title: LineEdit = %NewTerrainTitle
@onready var terrain_size_x: SpinBox = %Size/X
@onready var terrain_size_y: SpinBox = %Size/Y
@onready var terrain_grid_x: SpinBox = %GridStart/X
@onready var terrain_grid_y: SpinBox = %GridStart/Y
@onready var base_elevation: SpinBox = %BaseElevation
@onready var meta_country: LineEdit = %MetaCountry
@onready var meta_edition: LineEdit = %MetaEdition
@onready var meta_series: LineEdit = %MetaSeries
@onready var meta_sheet: LineEdit = %MetaSheet
@onready var create_btn: Button = %Create
@onready var cancel_btn: Button = %Cancel


func _ready():
	create_btn.pressed.connect(_on_primary_pressed)
	cancel_btn.pressed.connect(func(): show_dialog(false))
	close_requested.connect(func(): show_dialog(false))


## Open the dialog for creating a new terrain (optionally pass defaults).
func open_for_create(
	title_text: String = "",
	size_x_m: int = 2000,
	size_y_m: int = 2000,
	grid_start_x_m: int = 100,
	grid_start_y_m: int = 100,
	base_elev_m: float = 110.0
) -> void:
	_is_edit_mode = false
	_target_data = null
	_window_title_and_cta()
	_fill_fields_for_create(
		title_text, size_x_m, size_y_m, grid_start_x_m, grid_start_y_m, base_elev_m
	)
	show_dialog(true)


## Open the dialog for editing an existing TerrainData
func open_for_edit(data: TerrainData) -> void:
	if data == null:
		push_warning("open_for_edit: no TerrainData provided; falling back to create mode.")
		open_for_create()
		return
	_is_edit_mode = true
	_target_data = data
	_window_title_and_cta()
	_fill_fields_from_data(data)
	show_dialog(true)


func _on_primary_pressed():
	var sx := int(terrain_size_x.value)
	var sy := int(terrain_size_y.value)
	if sx <= 0 or sy <= 0:
		push_warning("Terrain size must be > 0.")
		return

	if _is_edit_mode and _target_data != null:
		_target_data.name = terrain_title.text
		_target_data.width_m = sx
		_target_data.height_m = sy
		_target_data.grid_start_x = int(terrain_grid_x.value)
		_target_data.grid_start_y = int(terrain_grid_y.value)
		_target_data.base_elevation_m = int(base_elevation.value)
		_target_data.country = meta_country.text
		_target_data.map_scale = "1:25,000"
		_target_data.edition = meta_edition.text
		_target_data.series = meta_series.text
		_target_data.sheet = meta_sheet.text

		show_dialog(false)
		emit_signal("request_edit", _target_data)
	else:
		var data := TerrainData.new()
		data.name = terrain_title.text
		data.width_m = sx
		data.height_m = sy
		data.grid_start_x = int(terrain_grid_x.value)
		data.grid_start_y = int(terrain_grid_y.value)
		data.base_elevation_m = int(base_elevation.value)
		data.country = meta_country.text
		data.map_scale = "1:25,000"
		data.edition = meta_edition.text
		data.series = meta_series.text
		data.sheet = meta_sheet.text

		show_dialog(false)
		emit_signal("request_create", data)


func _fill_fields_for_create(
	title_text: String,
	size_x_m: int,
	size_y_m: int,
	grid_start_x_m: int,
	grid_start_y_m: int,
	base_elev_m: float
) -> void:
	terrain_title.text = title_text
	terrain_size_x.value = size_x_m
	terrain_size_y.value = size_y_m
	terrain_grid_x.value = grid_start_x_m
	terrain_grid_y.value = grid_start_y_m
	base_elevation.value = base_elev_m


func _fill_fields_from_data(data: TerrainData) -> void:
	terrain_title.text = data.name
	terrain_size_x.value = int(data.width_m)
	terrain_size_y.value = int(data.height_m)
	terrain_grid_x.value = int(data.grid_start_x)
	terrain_grid_y.value = int(data.grid_start_y)
	base_elevation.value = float(data.base_elevation_m)
	meta_country.text = data.country
	meta_edition.text = data.edition
	meta_series.text = data.series
	meta_sheet.text = data.sheet


func _window_title_and_cta() -> void:
	title = "Edit Terrain" if _is_edit_mode else "Create New Terrain"
	create_btn.text = "Save" if _is_edit_mode else "Create"


## Reset values before popup (only when hiding)
func _reset_values():
	terrain_title.text = ""
	terrain_size_x.value = 2000
	terrain_size_y.value = 2000
	terrain_grid_x.value = 100
	terrain_grid_y.value = 100
	base_elevation.value = 110
	meta_country.text = ""
	meta_edition.text = ""
	meta_series.text = ""
	meta_sheet.text = ""


## Show/hide dialog
func show_dialog(state: bool):
	visible = state
	if not state:
		_is_edit_mode = false
		_target_data = null
		_reset_values()
