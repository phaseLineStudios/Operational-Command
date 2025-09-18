extends Node3D

@export var camera_path: NodePath         # Camera3D used for mouse ray
@export var table_node: NodePath          # Root that contains table meshes (same as in camera rig)
@export var place_height_epsilon := 0.01  # Slight lift above tabletop to avoid z-fighting
@export var clamp_padding := 0.02         # Keep placement slightly inside the edge

# NEW: Hold point under the camera for inspect mode (assign in Inspector)
@export var hold_point_path: NodePath

# State
var _held: Node = null                    # Currently held PickupItem (or null)
var _dragging := false

# NEW: inspection state
var _inspecting: bool = false
var _held_inspect: Node = null

# Last in-bounds drag position on the table plane
var _last_valid_target: Vector3 = Vector3.ZERO
# margin so the object don’t sit exactly on the edge of the table on drop
@export var drop_guard_margin: float = 0.03

# Cached nodes
@onready var _cam: Camera3D = get_node_or_null(camera_path)
# NEW: cached hold point
@onready var _hold_point: Node3D = get_node_or_null(hold_point_path)

# World-space bounds of the table (auto-detected at _ready)
var _bx_min := 0.0
var _bx_max := 0.0
var _bz_min := 0.0
var _bz_max := 0.0
var _top_y  := 0.0
var _bounds_ready := false



func _ready() -> void:
	_init_table_bounds()

func _unhandled_input(event: InputEvent) -> void:
	# NEW: While inspecting, block other input and allow exit with E or Esc
	if _inspecting:
		if event is InputEventKey and event.pressed and not event.echo:
			if event.keycode == KEY_ESCAPE or event.keycode == KEY_E:
				_end_inspect()
		return

	# Begin drag on RMB press over a pickable
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed and not _dragging:
			_try_begin_drag(event.position)
		elif not event.pressed and _dragging:
			_end_drag(true)

	# NEW: Begin inspect (pickup) on LMB press
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_try_begin_inspect(event.position)

func _process(_delta: float) -> void:
	# NEW: do not run drag updates while inspecting (prevents transform fights)
	if _inspecting:
		return

	if _dragging and _held and _bounds_ready and _cam:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var world_target := _mouse_to_table(mouse_pos)
		# Clamp to table rectangle
		world_target.x = clamp(world_target.x, _bx_min + clamp_padding, _bx_max - clamp_padding)
		world_target.z = clamp(world_target.z, _bz_min + clamp_padding, _bz_max - clamp_padding)
		# Slight lift above the plane
		world_target.y = _top_y + place_height_epsilon
		_last_valid_target = world_target
		var item := _held as Node3D
		item.update_drag(world_target)

# --- Drag lifecycle (UNCHANGED) ---

func _try_begin_drag(mouse_pos: Vector2) -> void:
	if _inspecting:
		return
	if not _cam:
		push_warning("PlayerInteraction: camera_path not set.")
		return

	var from := _cam.project_ray_origin(mouse_pos)
	var dir  := _cam.project_ray_normal(mouse_pos)
	var to   := from + dir * 1000.0

	var space := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_bodies = true
	query.collide_with_areas  = true
	query.collision_mask      = 0x7fffffff   # hit everything

	var hit: Dictionary = space.intersect_ray(query)
	if hit.is_empty():
		return

	var collider: Object = hit.get("collider")
	if collider == null:
		return

	var item := _find_pickup_item(collider)
	if item:
		item.start_drag()
		_held = item
		_dragging = true

		# Seed _last_valid_target immediately
		var raw := _mouse_to_table(mouse_pos)
		var pad := clamp_padding + drop_guard_margin
		_last_valid_target.x = clamp(raw.x, _bx_min + pad, _bx_max - pad)
		_last_valid_target.z = clamp(raw.z, _bz_min + pad, _bz_max - pad)
		_last_valid_target.y = _top_y + place_height_epsilon

		item.update_drag(_last_valid_target)

func _end_drag(place_now: bool = false) -> void:
	if not _dragging:
		return
	_dragging = false
	if _held and _held.has_method("end_drag"):
		_held.end_drag()
	_held = null

# --- Inspect lifecycle (NEW, from the working sample) ---

func _try_begin_inspect(mouse_pos: Vector2) -> void:
	if _dragging or _cam == null:
		return

	var from := _cam.project_ray_origin(mouse_pos)
	var dir  := _cam.project_ray_normal(mouse_pos)
	var to   := from + dir * 1000.0

	var space := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_bodies = true
	query.collide_with_areas  = true
	query.collision_mask      = 0x7fffffff

	var hit := space.intersect_ray(query)
	if hit.is_empty():
		return

	var collider: Object = hit.get("collider")
	if collider == null:
		return

	var item := _find_pickup_item(collider)
	if item and item.has_method("begin_inspect"):
		var hold := _hold_point if _hold_point != null else _cam
		item.begin_inspect(_cam, hold)   # reparent + snap on next frame (see PickupItem.gd)
		_held_inspect = item
		_inspecting = true

func _end_inspect() -> void:
	if not _inspecting:
		return
	if _held_inspect and _held_inspect.has_method("end_inspect"):
		_held_inspect.end_inspect()
	_held_inspect = null
	_inspecting = false

# Walk up parents until a node with PickupItem API is found
func _find_pickup_item(obj: Object) -> Node:
	var n := obj
	while n is Node:
		if n.has_method("start_drag") and n.has_method("end_drag") and n.has_method("update_drag"):
			return n
		# also accept inspect-only items
		if n.has_method("begin_inspect") and n.has_method("end_inspect"):
			return n
		n = n.get_parent()
	return null

# Convert mouse position to intersection point on the tabletop plane
func _mouse_to_table(mouse_pos: Vector2) -> Vector3:
	var from := _cam.project_ray_origin(mouse_pos)
	var dir  := _cam.project_ray_normal(mouse_pos)
	var p := Vector3(0.0, _top_y, 0.0)
	var plane := Plane(p, p + Vector3.RIGHT, p + Vector3.FORWARD)
	var hit: Vector3 = plane.intersects_ray(from, dir)
	return hit if hit != null else from + dir * 2.0



# --- Bounds detection (UNCHANGED) ---

func _init_table_bounds() -> void:
	if table_node == NodePath():
		push_warning("PlayerInteraction: table_node not set.")
		return
	var root := get_node_or_null(table_node)
	if root == null:
		push_warning("PlayerInteraction: table_node path not found.")
		return
	var meshes := _gather_meshes(root)
	if meshes.is_empty():
		push_warning("PlayerInteraction: no MeshInstance3D under table_node.")
		return

	var world_aabb := _world_aabb_for_mesh(meshes[0])
	for i in range(1, meshes.size()):
		world_aabb = world_aabb.merge(_world_aabb_for_mesh(meshes[i]))

	_bx_min = world_aabb.position.x
	_bz_min = world_aabb.position.z
	_bx_max = world_aabb.position.x + world_aabb.size.x
	_bz_max = world_aabb.position.z + world_aabb.size.z
	_top_y  = world_aabb.position.y + world_aabb.size.y
	_bounds_ready = true

func _gather_meshes(n: Node) -> Array:
	var out: Array = []
	if n is MeshInstance3D:
		out.append(n)
	for c in n.get_children():
		out.append_array(_gather_meshes(c))
	return out

func _world_aabb_for_mesh(mi: MeshInstance3D) -> AABB:
	var aabb: AABB = mi.get_aabb()
	var xf: Transform3D = mi.global_transform
	var corners := [
		aabb.position,
		aabb.position + Vector3(aabb.size.x, 0, 0),
		aabb.position + Vector3(0, aabb.size.y, 0),
		aabb.position + Vector3(0, 0, aabb.size.z),
		aabb.position + Vector3(aabb.size.x, aabb.size.y, 0),
		aabb.position + Vector3(aabb.size.x, 0, aabb.size.z),
		aabb.position + Vector3(0, aabb.size.y, aabb.size.z),
		aabb.position + aabb.size
	]
	var w0: Vector3 = xf * corners[0]
	var min_v: Vector3 = w0
	var max_v: Vector3 = w0
	for i in range(1, corners.size()):
		var w: Vector3 = xf * corners[i]
		min_v = min_v.min(w)
		max_v = max_v.max(w)
	return AABB(min_v, max_v - min_v)
