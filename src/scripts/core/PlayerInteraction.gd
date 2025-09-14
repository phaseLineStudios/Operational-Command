extends Node3D

@export var camera_path: NodePath         # Camera3D used for mouse ray
@export var table_node: NodePath          # Root that contains table meshes (same as in camera rig)
@export var place_height_epsilon := 0.01  # Slight lift above tabletop to avoid z-fighting
@export var clamp_padding := 0.02         # Keep placement slightly inside the edge

# State
var _held: Node = null                    # Currently held PickupItem (or null)
var _dragging := false

# Cached nodes
@onready var _cam: Camera3D = get_node_or_null(camera_path)

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
	# Begin drag on RMB press over a pickable
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed and not _dragging:
			_try_begin_drag(event.position)
		elif not event.pressed and _dragging:
			_end_drag(true)
	# While dragging, also allow cancel via Esc/E if desired later

func _process(_delta: float) -> void:
	if _dragging and _held and _bounds_ready and _cam:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var world_target := _mouse_to_table(mouse_pos)
		# Clamp to table rectangle
		world_target.x = clamp(world_target.x, _bx_min + clamp_padding, _bx_max - clamp_padding)
		world_target.z = clamp(world_target.z, _bz_min + clamp_padding, _bz_max - clamp_padding)
		# Slight lift above the plane
		world_target.y = _top_y + place_height_epsilon
		var item := _held as Node3D
		item.update_drag(world_target)

# --- Drag lifecycle ---

func _try_begin_drag(mouse_pos: Vector2) -> void:
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

func _end_drag(place_now: bool = false) -> void:
	if _held:
		(_held as Node).end_drag(place_now)
	_held = null
	_dragging = false

# Walk up parents until a node with PickupItem API is found
func _find_pickup_item(obj: Object) -> Node:
	var n := obj
	while n is Node:
		if n.has_method("start_drag") and n.has_method("end_drag") and n.has_method("update_drag"):
			return n
		n = n.get_parent()
	return null

# Convert mouse position to intersection point on the tabletop plane
func _mouse_to_table(mouse_pos: Vector2) -> Vector3:
	var from := _cam.project_ray_origin(mouse_pos)
	var dir  := _cam.project_ray_normal(mouse_pos)
	var p := Vector3(0.0, _top_y, 0.0)
	var plane := Plane(p, p + Vector3.RIGHT, p + Vector3.FORWARD) # unambiguous y = _top_y
	var hit: Vector3 = plane.intersects_ray(from, dir)
	return hit if hit != null else from + dir * 2.0



# --- Bounds detection (same idea as your camera rig, without forward_offset) ---

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
