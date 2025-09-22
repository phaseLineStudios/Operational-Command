## File: PickupItem.gd

extends Node3D

# =========================
# Config
# =========================
@export var drag_lift: float = 0.025					# visual hover above plane during drag
@export var inspect_clearance: float = 0.02			# small Y lift while inspecting
@export var use_face_camera: bool = true			# optional: face camera on inspect
@export var inspect_rotation_deg := Vector3(90, 0, 0)	# <— TUNE THIS to fix inspect rotation (degrees, local)

# =========================
# Shared State
# =========================
var is_held: bool = false							# used by drag; also guards inspect updates
var is_inspecting: bool = false

# Physics/visual references (resolved at runtime so names don't need to match exactly)
@onready var _static_body: StaticBody3D = _find_first_static_body(self)
@onready var _mesh: MeshInstance3D = _find_first_mesh(self)

# Physics saved state
var _saved_layer: int = 0
var _saved_mask: int = 0
var _colliders: Array[CollisionShape3D] = []
var _colliders_prev_disabled: Array[bool] = []

# Drag saved state
var _prev_parent: Node = null
var _prev_index: int = 0
var _prev_global: Transform3D
var _orig_scale: Vector3
var _drag_offset_world: Vector3 = Vector3.ZERO

# Inspect return state (separate from drag so we don't cross wires)
var _inspect_prev_parent: Node = null
var _inspect_prev_index: int = 0
var _inspect_prev_global: Transform3D
var _inspect_prev_scale: Vector3

# =========================
# DRAG API
# =========================

## Function: start_drag
## Purpose: [documented]
## Parameters: none
## Returns: void
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

	# Compensate for StaticBody3D offset (if visuals are offset from root)
	_drag_offset_world = Vector3.ZERO
	if _static_body:
		_drag_offset_world = _static_body.global_transform.origin - global_transform.origin

## Function: update_drag
## Purpose: [documented]
## Parameters:
##  - world_pos: [see implementation]
## Returns: void
func update_drag(world_pos: Vector3) -> void:
	if not is_held or is_inspecting:
		return

	# Keep bottom near plane + lift (use mesh AABB if available)
	var bottom := 0.0
	if _mesh:
		var aabb: AABB = _mesh.get_aabb()
		bottom = aabb.position.y * scale.y

	var xf := global_transform
	var tgt := world_pos - _drag_offset_world
	tgt.y = world_pos.y - bottom + drag_lift
	xf.origin = tgt
	global_transform = xf

## Function: end_drag
## Purpose: [documented]
## Parameters: none
## Returns: void
func end_drag() -> void:
	if not is_held:
		return
	is_held = false

	# --- SNAP TO TABLE BEFORE RESTORING COLLISIONS ---
	var space := get_world_3d().direct_space_state
	var from := global_transform.origin + Vector3(0, 2.0, 0)
	var to := global_transform.origin + Vector3(0, -5.0, 0)
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.collide_with_bodies = true
	params.collide_with_areas = false
	var hit := space.intersect_ray(params)

	if hit.has("position"):
		var p: Vector3 = hit.position
		var bottom := 0.0
		if _mesh:
			var aabb: AABB = _mesh.get_aabb()
			bottom = aabb.position.y * scale.y
		var xf := global_transform
		xf.origin.y = p.y - bottom + 0.002
		global_transform = xf
		rotation_degrees.x = 0.0
		rotation_degrees.z = 0.0

	# Restore scale
	scale = _orig_scale

	# Restore collisions
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask = _saved_mask
	for i in _colliders.size():
		var cs: CollisionShape3D = _colliders[i]
		if is_instance_valid(cs):
			cs.disabled = _colliders_prev_disabled[i]

# =========================
# INSPECT (reparent → wait 1 frame → snap to HoldPoint → offset + rotation)
# =========================

## Function: begin_inspect
## Purpose: [documented]
## Parameters:
##  - cam: [see implementation]
##  - hold_point: [see implementation]
## Returns: void
func begin_inspect(cam: Camera3D, hold_point: Node3D) -> void:
	if is_inspecting:
		return
	if hold_point == null:
		push_warning("PickupItem.begin_inspect: hold_point missing.")
		return

	is_inspecting = true
	is_held = true  # block drag updates while inspecting

	# Save original placement & scale to restore on end_inspect
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

	# Reparent safely; keep_global = true to avoid a visible jump this frame
	reparent(hold_point, true)

	# Defer the snap one frame so no other system fights this transform
	await get_tree().process_frame

	# Snap to HoldPoint world pose so we follow it from now on
	global_transform = hold_point.global_transform

	# LOCAL lift so the visual "bottom" is above the hold plane
	var bottom_offset := 0.0
	if _mesh:
		var aabb: AABB = _mesh.get_aabb()
		bottom_offset = aabb.position.y * scale.y

	# Reset local to identity, keep scale, then apply a small local offset
	transform = Transform3D.IDENTITY
	scale = _inspect_prev_scale
	var local := transform
	local.origin = Vector3(0.0, -bottom_offset + inspect_clearance, 0.0)
	transform = local

	# ---- ORIENTATION CONTROL (tweak here) ----
	if use_face_camera and cam:
		# Face the camera, then apply extra local Euler offset
		look_at(cam.global_transform.origin, Vector3.UP)
		rotate_object_local(Vector3.RIGHT, deg_to_rad(inspect_rotation_deg.x))
		rotate_object_local(Vector3.UP, deg_to_rad(inspect_rotation_deg.y))
		rotate_object_local(Vector3.FORWARD, deg_to_rad(inspect_rotation_deg.z))
	else:
		# Purely local orientation relative to HoldPoint
		rotation_degrees = inspect_rotation_deg

## Function: end_inspect
## Purpose: [documented]
## Parameters: none
## Returns: void
func end_inspect() -> void:
	if not is_inspecting:
		return

	# Restore original parent (keep current world while switching)
	if _inspect_prev_parent and is_instance_valid(_inspect_prev_parent):
		reparent(_inspect_prev_parent, true)
	else:
		push_warning("PickupItem.end_inspect: previous parent missing; keeping current parent.")

	# Defer transform write one frame (mirrors begin_inspect)
	await get_tree().process_frame

	# Restore exact transform from pickup moment
	if _inspect_prev_global:
		global_transform = _inspect_prev_global

	# Restore physics
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask  = _saved_mask
	for i in range(_colliders.size()):
		var cs: CollisionShape3D = _colliders[i]
		if is_instance_valid(cs):
			cs.set_deferred("disabled", _colliders_prev_disabled[i])

	is_inspecting = false
	is_held = false

# =========================
# Utilities
# =========================

## Function: _collect_collision_shapes
## Purpose: [documented]
## Parameters:
##  - n: [see implementation]
## Returns: Array[CollisionShape3D]
func _collect_collision_shapes(n: Node) -> Array[CollisionShape3D]:
	var out: Array[CollisionShape3D] = []
	if n is CollisionShape3D:
		out.append(n)
	for c in n.get_children():
		out.append_array(_collect_collision_shapes(c))
	return out

## Function: _find_first_static_body
## Purpose: [documented]
## Parameters:
##  - n: [see implementation]
## Returns: StaticBody3D
func _find_first_static_body(n: Node) -> StaticBody3D:
	if n is StaticBody3D:
		return n
	for c in n.get_children():
		var sb := _find_first_static_body(c)
		if sb:
			return sb
	return null

## Function: _find_first_mesh
## Purpose: [documented]
## Parameters:
##  - n: [see implementation]
## Returns: MeshInstance3D
func _find_first_mesh(n: Node) -> MeshInstance3D:
	if n is MeshInstance3D:
		return n
	for c in n.get_children():
		var mi := _find_first_mesh(c)
		if mi:
			return mi
	return null
