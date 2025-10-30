class_name StampLayer
extends Control
## Renders scenario stamps (drawings) on the terrain in 2D map space.

var _stamps: Array[ScenarioDrawingStamp] = []
var _texture_cache: Dictionary = {}  # path -> Texture2D


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


## Load stamps from scenario data.
## [param stamps] Array of ScenarioDrawingStamp to render.
func load_stamps(stamps: Array) -> void:
	_stamps.clear()
	_texture_cache.clear()

	for stamp in stamps:
		if stamp is ScenarioDrawingStamp and stamp.visible:
			_stamps.append(stamp)
			# Preload texture
			if stamp.texture_path != "" and ResourceLoader.exists(stamp.texture_path):
				if not _texture_cache.has(stamp.texture_path):
					var tex := load(stamp.texture_path) as Texture2D
					if tex:
						_texture_cache[stamp.texture_path] = tex

	LogService.info("StampLayer loaded %d stamps" % _stamps.size(), "StampLayer.gd")
	queue_redraw()


## Clear all stamps.
func clear_stamps() -> void:
	_stamps.clear()
	_texture_cache.clear()
	queue_redraw()


func _draw() -> void:
	if _stamps.is_empty():
		return

	# Get TerrainRender parent for coordinate conversion
	var terrain_render := _get_terrain_render()
	if not terrain_render:
		LogService.warning("StampLayer: Cannot find TerrainRender parent", "StampLayer.gd")
		return

	for stamp in _stamps:
		_draw_stamp(stamp, terrain_render)


## Draw a single stamp.
func _draw_stamp(stamp: ScenarioDrawingStamp, _terrain_render: TerrainRender) -> void:
	# Get texture
	var tex := _texture_cache.get(stamp.texture_path) as Texture2D
	if not tex:
		return

	# Calculate size in pixels
	var sz: Vector2 = tex.get_size() * stamp.scale

	# Calculate tint color with opacity
	var tint: Color = stamp.modulate
	tint.a *= stamp.opacity

	# Draw stamp centered at position with rotation
	draw_set_transform(stamp.position_m, deg_to_rad(stamp.rotation_deg))
	draw_texture_rect(tex, Rect2(-sz * 0.5, sz), false, tint)
	draw_set_transform(Vector2.ZERO, 0.0)

	# Draw label if present
	if stamp.label != null and stamp.label != "":
		_draw_stamp_label(stamp.label, stamp.position_m, sz.x * 0.5, tint)


## Draw label next to stamp.
func _draw_stamp_label(text: String, pos_px: Vector2, offset_x: float, color: Color) -> void:
	var font := get_theme_default_font()
	var font_size := 24

	# Position label to the right of stamp
	var label_pos := pos_px + Vector2(offset_x + 5, 0)

	# Draw text with slight outline for visibility
	draw_string(font, label_pos + Vector2(1, 1), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.BLACK)
	draw_string(font, label_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)


## Get parent TerrainRender node.
func _get_terrain_render() -> TerrainRender:
	var node := get_parent()
	while node:
		if node is TerrainRender:
			return node as TerrainRender
		node = node.get_parent()
	return null
