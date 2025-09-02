extends TerrainToolBase
class_name TerrainPolygonTool

## Elevation editing: raise/lower/smooth brush.

@export var active_brush: TerrainBrush

var _points_m := PackedVector2Array()
var _hover_idx := -1
var _drag_idx := -1
var _is_drag := false
var _pick_radius_px := 10.0

func _init():
	tool_icon = preload("res://assets/textures/ui/editors_polygon_tool.png")
	tool_hint = "Polygon Tool"

func _load_brushes() -> void:
	brushes.clear()
	var dir := DirAccess.open("res://assets/terrain_brushes/")
	if dir:
		for f in dir.get_files():
			if f.ends_with(".tres") or f.ends_with(".res"):
				var r := ResourceLoader.load("res://assets/terrain_brushes/%s" % f)
				if r is TerrainBrush:
					brushes.append(r)

func build_preview(overlay_parent: Node) -> Control:
	return Control.new()

func _place_preview(local_px: Vector2) -> void:
	if _preview:
		_preview.queue_redraw()

func build_options_ui(p: Control) -> void:
	_load_brushes()
	
	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.add_child(vb)

	vb.add_child(_label("Feature Brush"))

	var list := ItemList.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	list.custom_minimum_size = Vector2(0, 160)

	var map_index := []
	for brush_idx in brushes.size():
		var brush = brushes[brush_idx]
		if brush.feature_type != TerrainBrush.FeatureType.AREA:
			continue
		list.add_item(brush.legend_title)
		map_index.append(brush_idx)
		
	list.item_selected.connect(func(i):
		if i >= 0 and i < map_index.size():
			active_brush = brushes[map_index[i]]
	)

	vb.add_child(list)

func build_info_ui(parent: Control) -> void:
	var l = Label.new()
	l.text = ""
	parent.add_child(l)

## Helper function to create a new label
func _label(t: String) -> Label:
	var l := Label.new()
	l.text = t
	return l

func handle_view_input(event: InputEvent) -> bool:
	return false
