@tool
class_name UnitCounter
extends Node3D

## Emitted when the counter texture has been generated and is ready for display
signal texture_ready

enum CounterAffiliation { PLAYER, FRIEND, ENEMY, NEUTRAL, UNKNOWN }

@export var affiliation: CounterAffiliation = CounterAffiliation.PLAYER
@export var callsign: String = "ALPHA"

@export_group("Unit Symbol")
@export var symbol_type: MilSymbol.UnitType = MilSymbol.UnitType.INFANTRY
@export var symbol_size: MilSymbol.UnitSize = MilSymbol.UnitSize.COMPANY

@export_group("Performance")
@export var free_face_renderer_after_bake: bool = true

## Cache baked face textures to avoid repeated viewport readbacks.
const _FACE_CACHE_MAX_ENTRIES: int = 128
static var _face_texture_cache: Dictionary = {}  # cache_key -> Texture2D
static var _face_cache_order: Array[String] = []

@onready var mesh: MeshInstance3D = %Mesh.get_node_or_null("unit_counter")
@onready var face_renderer: SubViewport = %FaceRenderer
@onready var face_background: PanelContainer = %Background
@onready var face_symbol: TextureRect = %Symbol
@onready var face_callsign: Label = %Callsign


## Setup the counter with parameters (call before adding to scene tree)
func setup(
	p_affiliation: MilSymbol.UnitAffiliation,
	p_unit_type: MilSymbol.UnitType,
	p_unit_size: MilSymbol.UnitSize,
	p_callsign: String
) -> void:
	affiliation = _mil_affiliation_to_counter(p_affiliation)
	symbol_type = p_unit_type
	symbol_size = p_unit_size
	callsign = p_callsign


func _ready() -> void:
	var color := _get_base_color()

	var face := await _generate_face(color)
	_ensure_mesh_materials(color, face)

	# Emit signal when texture generation is complete
	texture_ready.emit()


func _ensure_mesh_materials(color: Color, face: Texture2D) -> void:
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = color
	mesh.set_surface_override_material(0, body_mat)

	var face_mat: StandardMaterial3D = (
		load("res://assets/models/unit_counter/UnitCounterFace.material").duplicate()
	)
	face_mat.albedo_texture = face
	mesh.set_surface_override_material(1, face_mat)


static func _face_cache_key(
	aff: CounterAffiliation,
	p_callsign: String,
	p_symbol_type: MilSymbol.UnitType,
	p_symbol_size: MilSymbol.UnitSize,
	bg: Color
) -> String:
	return (
		JSON
		. stringify(
			[
				int(aff),
				p_callsign,
				int(p_symbol_type),
				int(p_symbol_size),
				float(bg.r),
				float(bg.g),
				float(bg.b),
				float(bg.a),
			]
		)
	)


func _maybe_free_face_renderer() -> void:
	if face_renderer:
		face_renderer.render_target_update_mode = SubViewport.UPDATE_DISABLED

	if free_face_renderer_after_bake and not Engine.is_editor_hint():
		if face_renderer:
			face_renderer.queue_free()
		face_renderer = null
		face_background = null
		face_symbol = null
		face_callsign = null


func _generate_face(color: Color) -> Texture2D:
	var key := _face_cache_key(affiliation, callsign, symbol_type, symbol_size, color)
	var cached: Variant = _face_texture_cache.get(key, null)
	if cached is Texture2D:
		_maybe_free_face_renderer()
		return cached

	# Create frame-only symbol (white lines) using enum-based API
	var config := MilSymbolConfig.create_frame_only()
	config.size = MilSymbolConfig.Size.LARGE
	config.resolution_scale = 4.0  # High quality for counter face

	var generator := MilSymbol.new(config)
	var mil_affiliation := _counter_to_mil_affiliation(affiliation)
	var unit_symbol := await generator.generate(mil_affiliation, symbol_type, symbol_size, "")
	generator.cleanup()

	# Setup the face elements
	face_symbol.texture = unit_symbol
	face_symbol.modulate = Color(0.0, 0.0, 0.0)
	face_callsign.text = callsign

	# Set background color (duplicate to avoid sharing between counters)
	var sb: StyleBoxFlat = face_background.get_theme_stylebox("panel").duplicate()
	sb.bg_color = color
	face_background.add_theme_stylebox_override("panel", sb)

	# Update the (disabled-by-default) viewport once to bake the face texture.
	if face_renderer:
		face_renderer.render_target_update_mode = SubViewport.UPDATE_ONCE

	# Wait for viewport to render
	await get_tree().process_frame
	await get_tree().process_frame

	if face_renderer == null:
		LogService.warning("UnitCounter: FaceRenderer missing", "UnitCounter.gd")
		return unit_symbol

	var img := face_renderer.get_texture().get_image()
	img.generate_mipmaps()

	var tex: Texture2D = ImageTexture.create_from_image(img)
	_face_texture_cache[key] = tex
	_face_cache_order.append(key)
	if _face_cache_order.size() > _FACE_CACHE_MAX_ENTRIES:
		var old_key: String = _face_cache_order.pop_front()
		_face_texture_cache.erase(old_key)

	_maybe_free_face_renderer()
	return tex


## Convert CounterAffiliation to MilSymbol.UnitAffiliation
func _counter_to_mil_affiliation(aff: CounterAffiliation) -> MilSymbol.UnitAffiliation:
	match aff:
		CounterAffiliation.PLAYER, CounterAffiliation.FRIEND:
			return MilSymbol.UnitAffiliation.FRIEND
		CounterAffiliation.ENEMY:
			return MilSymbol.UnitAffiliation.ENEMY
		CounterAffiliation.NEUTRAL:
			return MilSymbol.UnitAffiliation.NEUTRAL
		CounterAffiliation.UNKNOWN:
			return MilSymbol.UnitAffiliation.UNKNOWN
		_:
			return MilSymbol.UnitAffiliation.UNKNOWN


## Convert MilSymbol.UnitAffiliation to CounterAffiliation
func _mil_affiliation_to_counter(aff: MilSymbol.UnitAffiliation) -> CounterAffiliation:
	match aff:
		MilSymbol.UnitAffiliation.FRIEND:
			return CounterAffiliation.PLAYER
		MilSymbol.UnitAffiliation.ENEMY:
			return CounterAffiliation.ENEMY
		MilSymbol.UnitAffiliation.NEUTRAL:
			return CounterAffiliation.NEUTRAL
		MilSymbol.UnitAffiliation.UNKNOWN:
			return CounterAffiliation.UNKNOWN
		_:
			return CounterAffiliation.UNKNOWN


func _get_base_color() -> Color:
	match affiliation:
		CounterAffiliation.PLAYER:
			return Color(0.612, 0.682, 0.722)
		CounterAffiliation.FRIEND:
			return Color(0.647, 0.718, 0.89)
		CounterAffiliation.ENEMY:
			return Color(0.898, 0.212, 0.224)
		CounterAffiliation.NEUTRAL:
			return Color(0.667, 1.0, 0.667, 1.0)
		CounterAffiliation.UNKNOWN:
			return Color(1.0, 1.0, 0.502, 1.0)
		_:
			return Color(1.0, 1.0, 1.0)
