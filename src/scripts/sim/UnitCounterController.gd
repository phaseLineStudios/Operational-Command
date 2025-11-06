class_name UnitCounterController
extends Node

## Opens CounterConfigDialog when the user clicks the 3D drawer and spawns counters.

const UNIT_COUNTER_SCENE := preload("res://scenes/system/unit_counter.tscn")

## The 3D drawer object (must have a CollisionShape3D).
@export var drawer: StaticBody3D
## The UI dialog to show when clicked.
@export var counter_dialog: CounterConfigDialog

## Track the number of counters created
var _counter_count: int = 0

## Reference to map mesh for coordinate conversion
var _map_mesh: MeshInstance3D = null
## Reference to terrain renderer for coordinate conversion
var _terrain_render: TerrainRender = null


func _ready() -> void:
	## Ensure the drawer can receive ray-pick input, then wire its input signal.
	if drawer:
		# Required for 3D picking; also ensure the drawer is on some collision layer.
		drawer.input_ray_pickable = true
		# Connect the physics input signal emitted when this body is clicked/hovered.
		drawer.input_event.connect(_on_drawer_input_event)
	else:
		push_warning("unitCounterController: 'drawer' is not assigned.")

	if counter_dialog:
		counter_dialog.counter_create_requested.connect(_on_counter_create_requested)
	else:
		push_warning("unitCounterController: 'counter_dialog' is not assigned.")


## Handles click on the drawer and pops the dialog.
## [param _cam] Unused camera reference.
## [param event] The input event to check for mouse clicks.
## [param _pos] Unused hit position.
## [param _norm] Unused hit normal.
## [param _shape_idx] Unused shape index.
func _on_drawer_input_event(_cam, event: InputEvent, _pos, _norm, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if counter_dialog:
			counter_dialog.popup_centered()
			counter_dialog.grab_focus()
		else:
			push_warning("unitCounterController: 'counter_dialog' is not assigned.")


## Spawns a unit counter with the requested parameters.
## [param p_affiliation] The unit's affiliation (friend, enemy, etc.)
## [param p_type] The unit type (infantry, armor, etc.)
## [param p_size] The unit size/echelon (company, battalion, etc.)
## [param p_callsign] The unit's callsign identifier
func _on_counter_create_requested(
	p_affiliation: MilSymbol.UnitAffiliation,
	p_type: MilSymbol.UnitType,
	p_size: MilSymbol.UnitSize,
	p_callsign: String
) -> void:
	var counter: UnitCounter = UNIT_COUNTER_SCENE.instantiate()

	# Setup the counter with the requested parameters BEFORE adding to tree
	# (this is required so _ready() uses the correct values)
	counter.setup(p_affiliation, p_type, p_size, p_callsign)

	# Add to tree (this triggers _ready() which generates the face)
	%PhysicsObjects.add_child(counter)

	# Set spawn position
	var spawn_location: Marker3D = %CounterSpawnLocation
	if spawn_location:
		counter.global_position = spawn_location.global_position + Vector3(0.2, 0, 0)
	else:
		push_warning("unitCounterController: CounterSpawnLocation marker not found.")

	# Increment counter for trigger detection
	_counter_count += 1


## Get the total number of counters created by the player.
## Used by TriggerAPI to detect counter creation.
## [return] Number of counters created.
func get_counter_count() -> int:
	return _counter_count


## Initialize references for coordinate conversion.
## [param map_mesh] MeshInstance3D of the map plane
## [param terrain_render] TerrainRender for terrain data
func init(map_mesh: MeshInstance3D, terrain_render: TerrainRender) -> void:
	_map_mesh = map_mesh
	_terrain_render = terrain_render


## Spawn a unit counter at a specific terrain position.
## Used for automatic counter spawning (e.g., on contact spotted).
## [param p_affiliation] The unit's affiliation (friend, enemy, etc.)
## [param p_type] The unit type (infantry, armor, etc.)
## [param p_size] The unit size/echelon (company, battalion, etc.)
## [param p_callsign] The unit's callsign identifier
## [param pos_m] Position in terrain meters (Vector2)
func spawn_counter_at_position(
	p_affiliation: MilSymbol.UnitAffiliation,
	p_type: MilSymbol.UnitType,
	p_size: MilSymbol.UnitSize,
	p_callsign: String,
	pos_m: Vector2
) -> void:
	var counter: UnitCounter = UNIT_COUNTER_SCENE.instantiate()

	# Setup the counter with the requested parameters BEFORE adding to tree
	counter.setup(p_affiliation, p_type, p_size, p_callsign)

	# Add to tree (this triggers _ready() which generates the face)
	%PhysicsObjects.add_child(counter)

	# Convert terrain position to 3D world position
	var world_pos: Variant = _terrain_to_world(pos_m)
	if world_pos != null:
		# Place counter slightly above the map surface
		counter.global_position = world_pos + Vector3(0, 0.05, 0)
	else:
		# Fallback to spawn location if conversion fails
		var spawn_location: Marker3D = %CounterSpawnLocation
		if spawn_location:
			counter.global_position = spawn_location.global_position + Vector3(0.2, 0, 0)
		else:
			LogService.warning(
				"spawn_counter_at_position: Failed to place counter, no spawn location",
				"UnitCounterController.gd"
			)

	# Increment counter for trigger detection
	_counter_count += 1


## Convert terrain 2D position to 3D world position on the map.
## [param pos_m] Terrain position in meters.
## [return] World position as Vector3, or null if conversion fails.
func _terrain_to_world(pos_m: Vector2) -> Variant:
	if _terrain_render == null:
		LogService.warning("_terrain_to_world: _terrain_render is null", "UnitCounterController.gd")
		return null

	if _map_mesh == null or _map_mesh.mesh == null:
		LogService.warning(
			"_terrain_to_world: map_mesh or mesh is null", "UnitCounterController.gd"
		)
		return null

	var mesh_size := Vector2.ZERO
	if _map_mesh.mesh is PlaneMesh:
		mesh_size = _map_mesh.mesh.size
	else:
		LogService.warning(
			"_terrain_to_world: map_mesh.mesh is not PlaneMesh", "UnitCounterController.gd"
		)
		return null

	if _terrain_render.data == null:
		LogService.warning(
			"_terrain_to_world: terrain_render.data is null", "UnitCounterController.gd"
		)
		return null

	var terrain_width_m := float(_terrain_render.data.width_m)
	var terrain_height_m := float(_terrain_render.data.height_m)

	if terrain_width_m == 0 or terrain_height_m == 0:
		LogService.warning(
			"_terrain_to_world: terrain dimensions are zero", "UnitCounterController.gd"
		)
		return null

	# Normalize terrain position to -0.5..0.5 range (mesh local space)
	var normalized_x := (pos_m.x / terrain_width_m) - 0.5
	var normalized_z := (pos_m.y / terrain_height_m) - 0.5

	# Scale to mesh size
	var local_pos := Vector3(normalized_x * mesh_size.x, 0, normalized_z * mesh_size.y)

	# Convert to world space
	var world_pos := _map_mesh.to_global(local_pos)

	return world_pos
