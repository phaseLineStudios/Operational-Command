extends Node3D

# =========================
# Config
# =========================
@export var drag_lift: float = 0.1			# visual hover above plane while dragging
@export var inspect_distance: float = 0.6	# distance in front of camera when inspecting

# =========================
# Shared State
# =========================
var is_held: bool = false

# Physics / visuals (resolved by type so names don't matter)
@onready var _static_body: StaticBody3D = _find_first_static_body(self)
@onready var _mesh: MeshInstance3D = _find_first_mesh(self)

var _saved_layer: int = 0
var _saved_mask: int = 0
var _colliders: Array[CollisionShape3D] = []
var _colliders_prev_disabled: Array[bool] = []

# =========================
# Drag State
# =========================
var _prev_parent: Node = null
var _prev_index: int = 0
var _prev_global: Transform3D
var _orig_scale: Vector3
var _drag_offset_world: Vector3 = Vector3.ZERO

# =========================
# Inspect State
# =========================
var is_inspecting: bool = false
var _inspect_prev_parent: Node = null
var _inspect_prev_index: int = 0
var _inspect_prev_global: Transform3D
var _inspect_prev_scale: Vector3


# =========================
# Drag API
# =========================
func start_drag() -> void:
	if is_held or is_inspecting:
		return
	is_held = true

	_prev_parent = get_parent()
	_prev_index = get_index()
	_prev_global = global_transform
	_orig_scale = scale

	# Disable collisions while dragging
	if _static_body:
		_saved_layer = _static_body.collision_layer
		_saved_mask = _static_body.collision_mask
		_static_body.collision_layer = 0
		_static_body.collision_mask = 0

	_colliders = _collect_collision_shapes(self)
	_colliders_prev_disabled.clear()
	for cs in _colliders:
		_colliders_prev_disabled.append(cs.disabled)
		cs.set_deferred("disabled", true)

	# If mesh lives under StaticBody3D with offset, compensate during drag
	_drag_offset_world = Vector3.ZERO
	if _static_body:
		_drag_offset_world = _static_body.global_transform.origin - global_transform.origin


func update_drag(world_pos: Vector3) -> void:
	if not is_held or is_inspecting:
		return

	# Keep bottom of item at plane + lift; honor StaticBody offset if any
	var bottom := _compute_bottom_offset()

	var target := world_pos - _drag_offset_world
	target.y = world_pos.y - bottom + drag_lift

	var xf := global_transform
	xf.origin = target
	global_transform = xf


func end_drag() -> void:
	if not is_held:
		return
	is_held = false

	# Restore parent but keep current transform
	var keep := global_transform
	if _prev_parent:
		_prev_parent.add_child(self)
		_prev_parent.move_child(self, _prev_index)
		global_transform = keep

	# Restore scale
	scale = _orig_scale

	# Restore collisions
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask = _saved_mask
	for i in _colliders.size():
		_colliders[i].disabled = _colliders_prev_disabled[i]

	# Optional: try to snap to any collider below (requires table collider)
	var space_state := get_world_3d().direct_space_state
	var from_pos := global_transform.origin + Vector3(0, 2, 0)
	var to_pos := global_transform.origin + Vector3(0, -5, 0)

	var params := PhysicsRayQueryParameters3D.create(from_pos, to_pos)
	var result := space_state.intersect_ray(params)

	if result.has("position"):
		var hit: Vector3 = result.position
		var bottom_offset := _compute_bottom_offset()
		var xf2 := global_transform
		xf2.origin = hit - Vector3(0, bottom_offset, 0)
		global_transform = xf2
		# Lay flat
		rotation_degrees.x = 0
		rotation_degrees.z = 0


# Preferred by PlayerInteraction to avoid raycasts
func end_drag_with_target(table_y: float, target: Vector3) -> void:
	if not is_held:
		return
	is_held = false

	# Restore parent but keep current transform before setting final pose
	var keep := global_transform
	if _prev_parent:
		_prev_parent.add_child(self)
		_prev_parent.move_child(self, _prev_index)
		global_transform = keep

	# Restore scale
	scale = _orig_scale

	# Restore collisions
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask = _saved_mask
	for i in _colliders.size():
		_colliders[i].disabled = _colliders_prev_disabled[i]

	# Place on provided plane
	var bottom_offset := _compute_bottom_offset()
	var xf2 := global_transform
	xf2.origin.x = target.x
	xf2.origin.z = target.z
	xf2.origin.y = table_y - bottom_offset
	global_transform = xf2

	# Lay flat
	rotation_degrees.x = 0
	rotation_degrees.z = 0


# =========================
# Inspect API
# =========================
func begin_inspect(cam: Camera3D, hold_point: Node3D) -> void:
	if is_inspecting or is_held:
		return
	if cam == null:
		push_warning("PickupItem.begin_inspect: camera missing.")
		return
	# If no HoldPoint provided/path not set, fall back to the camera
	if hold_point == null:
		hold_point = cam

	is_held = true
	is_inspecting = true

	# Save exact return state
	_inspect_prev_parent = get_parent()
	_inspect_prev_index = get_index()
	_inspect_prev_global = global_transform
	_inspect_prev_scale = scale

	# Disable physics while inspecting
	if _static_body:
		_saved_layer = _static_body.collision_layer
		_saved_mask  = _static_body.collision_mask
		_static_body.collision_layer = 0
		_static_body.collision_mask  = 0

	_colliders = _collect_collision_shapes(self)
	_colliders_prev_disabled.clear()
	for cs in _colliders:
		_colliders_prev_disabled.append(cs.disabled)
		cs.set_deferred("disabled", true)

	# Choose placement:
	# - If a real HoldPoint is set, trust its global transform 1:1.
	# - If we fell back to the camera node, synthesize a point in front of it.
	var place: Transform3D
	if hold_point == cam:
		var tgt := cam.global_transform
		var fwd := -tgt.basis.z.normalized()
		place = tgt
		# Keep the item's *bottom* in front of the camera to avoid clipping into the near plane
		var bottom := _compute_bottom_offset()
		place.origin = tgt.origin + fwd * max(inspect_distance, 0.2) + Vector3(0, bottom, 0)
	else:
		place = hold_point.global_transform

	# Reparent under hold point while preserving transform, then move to 'place'
	var keep := global_transform
	hold_point.add_child(self)
	hold_point.move_child(self, hold_point.get_child_count() - 1)
	global_transform = keep
	global_transform = place

	# Face the camera (optional)
	look_at(cam.global_transform.origin, Vector3.UP)
	# Apply a correction so the mesh is rotated 90° around Y
	rotate_x(deg_to_rad(90))

func end_inspect() -> void:
	if not is_inspecting:
		return

	# Restore original parent & exact pickup transform
	var keep := global_transform
	if _inspect_prev_parent:
		_inspect_prev_parent.add_child(self)
		_inspect_prev_parent.move_child(self, _inspect_prev_index)
		global_transform = _inspect_prev_global
	else:
		global_transform = keep

	# Restore scale
	scale = _inspect_prev_scale

	# Restore physics
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask = _saved_mask
	for i in _colliders.size():
		_colliders[i].disabled = _colliders_prev_disabled[i]

	is_inspecting = false
	is_held = false


# =========================
# Utilities
# =========================
func get_footprint_radius() -> float:
	var r := 0.0
	if _mesh:
		var a := _mesh.get_aabb()
		r = 0.5 * max(a.size.x * scale.x, a.size.z * scale.z)
	return r


func _compute_bottom_offset() -> float:
	# Prefer mesh AABB for visual correctness
	if _mesh:
		var aabb := _mesh.get_aabb()
		return aabb.position.y * scale.y

	# Fallback: try first box shape height
	for cs in _colliders:
		if cs.shape is BoxShape3D:
			return (cs.shape.size.y * 0.5) * scale.y
	return 0.0


func _collect_collision_shapes(n: Node) -> Array[CollisionShape3D]:
	var out: Array[CollisionShape3D] = []
	if n is CollisionShape3D:
		out.append(n)
	for c in n.get_children():
		out.append_array(_collect_collision_shapes(c))
	return out


func _find_first_static_body(n: Node) -> StaticBody3D:
	if n is StaticBody3D:
		return n
	for c in n.get_children():
		var sb := _find_first_static_body(c)
		if sb:
			return sb
	return null


func _find_first_mesh(n: Node) -> MeshInstance3D:
	if n is MeshInstance3D:
		return n
	for c in n.get_children():
		var mi := _find_first_mesh(c)
		if mi:
			return mi
	return null
