extends Node2D
class_name SetupController

## Wires TerrainRender, PathGrid, and a MovementAgent, then handles click-to-move.

@onready var renderer: TerrainRender = %TerrainRender
@onready var camera: Camera2D = %TerrainCamera
@onready var unit: MovementAgent = %ExampleUnit
@onready var input_overlay: Control = %InputOverlay

func _ready() -> void:
	if renderer == null or renderer.data == null:
		push_warning("Setup: TerrainRender or TerrainData missing.")
		return
	if renderer.path_grid == null:
		push_warning("Setup: Assign PathGrid to TerrainRender.path_grid in the Inspector.")
		return
	if unit == null:
		push_warning("Setup: ExampleUnit (MovementAgent) missing.")
		return

	unit.grid = renderer.path_grid
	unit.renderer = renderer

	renderer.path_grid.rebuild(unit.profile)

	renderer.path_grid.build_ready.connect(func(p):
		if p == unit.profile:
			print("PathGrid ready for profile:", p)
	)
	renderer.path_grid.build_failed.connect(func(reason):
		push_warning("PathGrid build failed: " + reason)
	)

	renderer.path_grid.debug_enabled = true
	renderer.path_grid.debug_layer = PathGrid.DebugLayer.WEIGHT
	
	input_overlay.gui_input.connect(_input)

func _input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		if renderer == null or unit == null:
			return
		var pos := (e as InputEventMouseButton).position
		if not renderer.is_inside_terrain(pos):
			print("outside terrain: ", pos)
			return
		var terrain_pos := renderer.map_to_terrain(pos)
		print(renderer.map_to_terrain(terrain_pos))
		print(renderer.pos_to_grid(terrain_pos))
		unit.move_to_m(terrain_pos)
