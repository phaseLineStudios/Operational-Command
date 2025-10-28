class_name UnitCounter
extends Node3D

enum CounterAffiliation { PLAYER, FRIEND, ENEMY, NEUTRAL, UNKNOWN }

@export var affiliation: CounterAffiliation = CounterAffiliation.PLAYER
@export var callsign: String = "ALPHA"

@export_group("Unit Symbol")
@export var symbol_type: MilSymbol.UnitType = MilSymbol.UnitType.INFANTRY
@export var symbol_size: MilSymbol.UnitSize = MilSymbol.UnitSize.COMPANY

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


func _ensure_mesh_materials(color: Color, face: Texture2D) -> void:
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = color
	mesh.set_surface_override_material(0, body_mat)

	var face_mat := StandardMaterial3D.new()
	face_mat.albedo_texture = face
	# Use nearest neighbor filtering to keep text sharp
	face_mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	mesh.set_surface_override_material(1, face_mat)


func _generate_face(color: Color) -> Texture2D:
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
	face_symbol.modulate = Color(0.0, 0.0, 0.0)  # Black symbol on colored background
	face_callsign.text = callsign

	# Set background color (duplicate to avoid sharing between counters)
	var sb: StyleBoxFlat = face_background.get_theme_stylebox("panel").duplicate()
	sb.bg_color = color
	face_background.add_theme_stylebox_override("panel", sb)

	# Wait for viewport to render
	await get_tree().process_frame
	await get_tree().process_frame  # Extra frame for stability

	return face_renderer.get_texture()


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
