class_name EngineerController
extends Node
## Manages engineer tasks: laying mines, demo charges, and building bridges.
##
## Responsibilities:
## - Identify engineer-capable units from equipment
## - Process engineer task orders (mine, demo, bridge)
## - Simulate task completion time
## - Emit signals for voice responses (confirm, start, complete)
## - Consume engineer ammunition from AmmoSystem

## Emitted when an engineer task is confirmed/accepted
signal task_confirmed(unit_id: String, task_type: String, target_pos: Vector2)
## Emitted when task work begins
signal task_started(unit_id: String, task_type: String, target_pos: Vector2)
## Emitted when task is completed
signal task_completed(unit_id: String, task_type: String, target_pos: Vector2)

## Engineer task types
enum TaskType { LAY_MINE, DEMO, BUILD_BRIDGE }

## Time to lay mines (seconds)
@export var mine_duration: float = 30.0
## Time to place demo charges (seconds)
@export var demo_duration: float = 20.0
## Time to build a bridge (seconds)
@export var bridge_duration: float = 60.0
## Required proximity to target position before task can start (meters)
@export var required_proximity_m: float = 15.0
## TerrainRender reference.
@export var terrain_renderer: TerrainRender

var _units: Dictionary = {}  ## unit_id -> ScenarioUnit
var _positions: Dictionary = {}
var _engineer_units: Dictionary = {}
var _active_tasks: Array[EngineerTask] = []
var _ammo_system: AmmoSystem = null


func _ready() -> void:
	add_to_group("EngineerController")


## Register a unit and check if it's engineer-capable.
## [param unit_id] The ScenarioUnit ID (with SLOT suffix if applicable).
## [param su] The ScenarioUnit to register.
func register_unit(unit_id: String, su: ScenarioUnit) -> void:
	_units[unit_id] = su
	var is_eng: bool = _is_engineer_unit(su)
	_engineer_units[unit_id] = is_eng


## Unregister a unit
func unregister_unit(unit_id: String) -> void:
	_units.erase(unit_id)
	_positions.erase(unit_id)
	_engineer_units.erase(unit_id)

	for i in range(_active_tasks.size() - 1, -1, -1):
		if _active_tasks[i].unit_id == unit_id:
			_active_tasks.remove_at(i)


## Update unit position
func set_unit_position(unit_id: String, pos: Vector2) -> void:
	_positions[unit_id] = pos


## Bind external systems
func bind_ammo_system(ammo_sys: AmmoSystem) -> void:
	_ammo_system = ammo_sys


## Check if a unit is engineer-capable
func is_engineer_unit(unit_id: String) -> bool:
	return _engineer_units.get(unit_id, false)


## Get available engineer ammunition types for a unit
func get_available_engineer_ammo(unit_id: String) -> Array[String]:
	var su: ScenarioUnit = _units.get(unit_id)
	if not su:
		return []

	var types: Array[String] = []

	if su.state_ammunition.get("ENGINEER_MINE", 0) > 0:
		types.append("ENGINEER_MINE")
	if su.state_ammunition.get("ENGINEER_DEMO", 0) > 0:
		types.append("ENGINEER_DEMO")
	if su.state_ammunition.get("ENGINEER_BRIDGE", 0) > 0:
		types.append("ENGINEER_BRIDGE")

	return types


## Request an engineer task
## Returns true if accepted, false if unable to comply
func request_task(unit_id: String, task_type: String, target_pos: Vector2) -> bool:
	var su: ScenarioUnit = _units.get(unit_id)
	if not su:
		LogService.warning("Engineer task failed: unit not found", "EngineerController")
		return false

	if not _engineer_units.get(unit_id, false):
		LogService.warning("Engineer task failed: unit not engineer", "EngineerController")
		return false

	var ammo_type := ""
	var duration := 0.0
	match task_type.to_upper():
		"MINE", "LAY_MINE":
			ammo_type = "ENGINEER_MINE"
			duration = mine_duration
		"DEMO", "DEMOLITION":
			ammo_type = "ENGINEER_DEMO"
			duration = demo_duration
		"BRIDGE", "BUILD_BRIDGE":
			ammo_type = "ENGINEER_BRIDGE"
			duration = bridge_duration
		_:
			LogService.warning("Engineer task failed: unknown task type", "EngineerController")
			return false

	var current_ammo: int = su.state_ammunition.get(ammo_type, 0)
	if current_ammo < 1:
		LogService.warning("Engineer task failed: no %s ammo" % ammo_type, "EngineerController")
		return false

	if _ammo_system:
		if not _ammo_system.consume(su.unit.id, ammo_type, 1):
			LogService.warning(
				"Engineer task ammo consumption failed for %s" % su.unit.id, "EngineerController"
			)
			return false

	var task := EngineerTask.new(unit_id, task_type, target_pos, duration)
	_active_tasks.append(task)

	LogService.debug("Emitting task_confirmed for %s" % unit_id, "EngineerController")
	emit_signal("task_confirmed", unit_id, task_type, target_pos)

	LogService.info(
		"Engineer task: %s performing %s at %s" % [unit_id, task_type, target_pos],
		"EngineerController"
	)

	return true


## Tick active engineer tasks
func tick(delta: float) -> void:
	for i in range(_active_tasks.size() - 1, -1, -1):
		var task: EngineerTask = _active_tasks[i]

		var unit_pos: Vector2 = _positions.get(task.unit_id, Vector2.ZERO)
		var distance: float = unit_pos.distance_to(task.target_pos)

		if distance > required_proximity_m:
			continue

		task.time_elapsed += delta

		if not task.started:
			LogService.debug("Emitting task_started for %s" % task.unit_id, "EngineerController")
			emit_signal("task_started", task.unit_id, task.task_type, task.target_pos)
			task.started = true

		if task.time_elapsed >= task.duration:
			_process_completion(task)
			_active_tasks.remove_at(i)


## Process task completion
## [param tasl] Engineer Task.
func _process_completion(task: EngineerTask) -> void:
	emit_signal("task_completed", task.unit_id, task.task_type, task.target_pos)

	match task.task_type.to_lower():
		"bridge", "build_bridge":
			_place_bridge(task.target_pos)
		"mine", "lay_mine":
			_place_mines(task.target_pos)
		"demo", "demolition":
			_place_demo(task.target_pos)

	LogService.info(
		(
			"Engineer task completed: %s finished %s at %s"
			% [task.unit_id, task.task_type, task.target_pos]
		),
		"EngineerController"
	)


## Place a bridge at the target position
func _place_bridge(target_pos: Vector2) -> void:
	if not terrain_renderer or not terrain_renderer.data:
		LogService.warning("Cannot place bridge: no terrain data bound", "EngineerController")
		return

	var water_feature: Variant = _find_nearest_water(target_pos)
	if water_feature == null:
		LogService.warning(
			"No water found near %s for bridge placement" % target_pos, "EngineerController"
		)
		return

	var bridge_endpoints := _calculate_bridge_span(water_feature, target_pos)
	if bridge_endpoints.is_empty():
		LogService.warning("Could not calculate bridge span", "EngineerController")
		return

	var start_pos: Vector2 = bridge_endpoints[0]
	var end_pos: Vector2 = bridge_endpoints[1]

	var bridge_brush: TerrainBrush = load("res://assets/terrain_brushes/bridge.tres")
	if not bridge_brush:
		bridge_brush = load("res://assets/terrain_brushes/primary_road.tres")
	if not bridge_brush:
		LogService.warning(
			"Bridge brush not found, bridge will not be visible", "EngineerController"
		)
		return

	var bridge_direction := (end_pos - start_pos).normalized()
	var perpendicular := Vector2(-bridge_direction.y, bridge_direction.x)

	var num_lines := 3
	var spacing := 5.0
	var half_width := (num_lines - 1) * spacing / 2.0

	for i in range(num_lines):
		var offset := (i - (num_lines - 1) / 2.0) * spacing
		var offset_start := start_pos + perpendicular * offset
		var offset_end := end_pos + perpendicular * offset

		var bridge_line := {
			"brush": bridge_brush,
			"points": PackedVector2Array([offset_start, offset_end]),
			"closed": false,
			"width_px": 3.0
		}
		terrain_renderer.data.add_line(bridge_line)

	_rebuild_pathfinding()

	LogService.info(
		(
			"Bridge placed from %s to %s (span: %.1fm, width: %.1fm)"
			% [start_pos, end_pos, start_pos.distance_to(end_pos), half_width * 2.0]
		),
		"EngineerController"
	)


## Find the nearest water feature to a position (checks both surfaces and lines)
func _find_nearest_water(pos: Vector2) -> Variant:
	if not terrain_renderer or not terrain_renderer.data:
		return null

	var terrain := terrain_renderer.data
	var nearest_feature: Variant = null
	var nearest_dist := INF

	for surface in terrain.surfaces:
		if not surface is Dictionary:
			continue

		if not _is_water_feature(surface):
			continue

		var points: PackedVector2Array = surface.get("points", PackedVector2Array())
		if points.size() == 0:
			continue

		var center := _calculate_center(points)
		var dist := pos.distance_to(center)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_feature = surface

	for line in terrain.lines:
		if not line is Dictionary:
			continue

		if not _is_water_feature(line):
			continue

		var points: PackedVector2Array = line.get("points", PackedVector2Array())
		if points.size() == 0:
			continue

		var center := _calculate_center(points)
		var dist := pos.distance_to(center)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_feature = line

	return nearest_feature


## Check if a terrain feature is water-related
func _is_water_feature(feature: Dictionary) -> bool:
	var brush_path: String = feature.get("brush_path", "")
	if (
		brush_path.to_lower().contains("water")
		or brush_path.to_lower().contains("creek")
		or brush_path.to_lower().contains("river")
	):
		return true

	var brush: TerrainBrush = feature.get("brush", null)
	if brush:
		if brush.mv_tracked == 0.0 and brush.mv_wheeled == 0.0 and brush.mv_foot == 0.0:
			return true
		var title := brush.legend_title.to_lower()
		if title.contains("water") or title.contains("creek") or title.contains("river"):
			return true

	return false


## Calculate center point of a polygon or line
func _calculate_center(points: PackedVector2Array) -> Vector2:
	if points.size() == 0:
		return Vector2.ZERO
	var center := Vector2.ZERO
	for p in points:
		center += p
	return center / points.size()


## Calculate optimal bridge span across water
func _calculate_bridge_span(water_surface: Dictionary, target_pos: Vector2) -> PackedVector2Array:
	var points: PackedVector2Array = water_surface.get("points", PackedVector2Array())
	if points.size() < 2:
		return PackedVector2Array()

	var best_start := Vector2.ZERO
	var best_end := Vector2.ZERO
	var shortest_span := INF

	for i in range(points.size()):
		var p1 := points[i]
		var next_i := (i + 1) % points.size()
		var p2 := points[next_i]

		var edge_center := (p1 + p2) / 2.0
		if target_pos.distance_to(edge_center) > 200.0:
			continue

		for j in range(i + 2, points.size()):
			var p3 := points[j]
			var next_j := (j + 1) % points.size()
			var p4 := points[next_j]

			var span_dist := edge_center.distance_to((p3 + p4) / 2.0)

			if span_dist < shortest_span:
				shortest_span = span_dist
				best_start = edge_center
				best_end = (p3 + p4) / 2.0

	if shortest_span == INF:
		var nearest_point := points[0]
		var nearest_dist := target_pos.distance_to(nearest_point)
		for p in points:
			var dist := target_pos.distance_to(p)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_point = p
		best_start = nearest_point

		var furthest_dist := 0.0
		for p in points:
			var dist := best_start.distance_to(p)
			if dist > furthest_dist:
				furthest_dist = dist
				best_end = p

	return PackedVector2Array([best_start, best_end])


## Place mines at the target position (stub)
func _place_mines(_target_pos: Vector2) -> void:
	# TODO: Add mine markers to terrain
	pass


## Place demo charges at the target position (stub)
func _place_demo(_target_pos: Vector2) -> void:
	# TODO: Add demo markers or destroy objects
	pass


## Rebuild pathfinding grid after terrain modification
func _rebuild_pathfinding() -> void:
	if not terrain_renderer or not terrain_renderer.path_grid:
		LogService.warning(
			"Cannot rebuild pathfinding: no path_grid available", "EngineerController"
		)
		return

	var path_grid: PathGrid = terrain_renderer.path_grid

	path_grid._astar_cache.clear()
	path_grid._slope_cache.clear()
	path_grid._line_dist_cache.clear()

	path_grid._lines_epoch += 1

	var profiles := [
		TerrainBrush.MoveProfile.TRACKED,
		TerrainBrush.MoveProfile.WHEELED,
		TerrainBrush.MoveProfile.FOOT,
		TerrainBrush.MoveProfile.RIVERINE
	]

	for profile in profiles:
		if path_grid.has_profile(profile):
			pass
		path_grid.rebuild(profile)

	LogService.info("Pathfinding grid rebuilt after bridge placement", "EngineerController")


## Check if unit has engineer ammunition
func _is_engineer_unit(su: ScenarioUnit) -> bool:
	if su.state_ammunition.get("ENGINEER_MINE", 0) > 0:
		return true
	if su.state_ammunition.get("ENGINEER_DEMO", 0) > 0:
		return true
	if su.state_ammunition.get("ENGINEER_BRIDGE", 0) > 0:
		return true

	return false


## Active engineer task data
class EngineerTask:
	var unit_id: String
	var task_type: String
	var target_pos: Vector2
	var duration: float
	var time_elapsed: float = 0.0
	var started: bool = false

	func _init(p_unit_id: String, p_task_type: String, p_target_pos: Vector2, p_duration: float):
		unit_id = p_unit_id
		task_type = p_task_type
		target_pos = p_target_pos
		duration = p_duration
