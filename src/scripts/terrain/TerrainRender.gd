extends Control
class_name TerrainRender

## Renders map: grid, margins, contours, surfaces, features, labels

## Terrain Data
@export var data: TerrainData : set = _set_data

## Visual Style
@export_group("Terrain Base")
@export var base_color: Color = Color(1.0, 1.0, 1.0)
@export var terrain_border_color: Color = Color(0.0, 0.0, 0.0)
@export var terrain_border_px: int = 1

@export_group("Margin")
## Font size for map title
@export var title_size: int = 24
@export var margin_color: Color = Color(1.0, 1.0, 1.0)
@export var margin_top_px: int = 50
@export var margin_bottom_px: int = 50
@export var margin_left_px: int = 50
@export var margin_right_px: int = 50

@export_group("Grid")
@export var grid_100m_color: Color = Color(0.2, 0.2, 0.2, 0.25)
@export var grid_1km_color: Color = Color(0.1, 0.1, 0.1, 0.5)
@export var grid_line_px: float = 1.0
@export var grid_1km_line_px: float = 2.0
@export var margin_bg: Color = Color(0.95, 0.95, 0.93, 1.0)
@export var map_bg: Color = Color(1, 1, 1, 1)
@export var margin_px: int = 64
@export var label_color: Color = Color(0.05, 0.05, 0.05, 1.0)
@export var label_font: Font
@export var label_size: int = 14

@export_group("Contours")
@export var contour_color: Color = Color(0.15, 0.15, 0.15, 0.7)
@export var contour_thick_color: Color = Color(0.1, 0.1, 0.1, 0.85)
@export var contour_px: float = 1.0
@export var contour_thick_every_m: int = 50

@onready var margin = %MapMargin
@onready var base_layer = %TerrainBase
@onready var surface_layer = %SurfaceLayer
@onready var feature_layer = %FeatureLayer
@onready var contour_layer = %ContourLayer
@onready var grid_layer: GridLayer = %GridLayer
@onready var label_layer = %LabelLayer

signal map_resize()

var _contours: Dictionary = {}
var _contours_dirty := true

func _ready():
	_apply_visuals_to_grid()
	_draw()
	grid_layer.queue_redraw()
	base_layer.resized.connect(_on_base_layer_resize)

func _set_data(d: TerrainData):
	_mark_all_dirty()
	data = d
	if data:
		data.changed.connect(_on_data_changed, CONNECT_DEFERRED | CONNECT_REFERENCE_COUNTED)
	call_deferred("_draw_map_size")
	call_deferred("_push_data_to_layers")

func _push_data_to_layers() -> void:
	if grid_layer and grid_layer.has_method("set_data"):
		grid_layer.set_data(data)
		grid_layer.queue_redraw()

	if margin and margin.has_method("set_data"):
		margin.title_size = title_size
		margin.label_font = label_font
		margin.label_size = label_size
		margin.label_color = label_color
		margin.margin_color = margin_color
		margin.margin_top_px = margin_top_px
		margin.margin_bottom_px = margin_bottom_px
		margin.margin_left_px = margin_left_px
		margin.margin_right_px = margin_right_px
		margin.margin_label_every_m = 100
		margin.set_data(data)
		margin.queue_redraw()
	
	if contour_layer and contour_layer.has_method("set_data"):
		contour_layer.set_data(data)
		contour_layer.apply_style(self)
		contour_layer.queue_redraw()
		
	queue_redraw()

func _on_data_changed() -> void:
	_mark_all_dirty()
	_draw_map_size()
	_push_data_to_layers()
	contour_layer.request_rebuild()
	queue_redraw()

func _mark_all_dirty() -> void:
	_contours_dirty = true
	_contours.clear()

func _apply_visuals_to_grid() -> void:
	if not grid_layer:
		return
	grid_layer.grid_100m_color = grid_100m_color
	grid_layer.grid_1km_color = grid_1km_color
	grid_layer.grid_line_px = grid_line_px
	grid_layer.grid_1km_line_px = grid_1km_line_px
	grid_layer.queue_redraw()

func _draw() -> void:
	if data == null: return
	_draw_map_size()
	
	# Draw Terrain Base
	var base_sb := StyleBoxFlat.new()
	base_sb.bg_color = base_color
	base_sb.set_border_width_all(terrain_border_px)
	base_sb.border_color = terrain_border_color
	base_layer.add_theme_stylebox_override("panel", base_sb)

func _draw_map_size() -> void:
	if data == null:
		return
	
	if margin:
		var base_size := data.get_size()
		var total := base_size + Vector2(margin_px * 2, margin_px * 2)
		margin.size = total
		
	size = margin.size

	if grid_layer:
		grid_layer.queue_redraw()
	if label_layer:
		label_layer.queue_redraw()
	queue_redraw()

## Emit a resize event for base layer
func _on_base_layer_resize():
	emit_signal("map_resize")

## API to get the map size
func get_map_size():
	return base_layer.size

## API to get the map position
func get_map_position():
	return base_layer.position
