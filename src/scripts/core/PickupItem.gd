# This script can be attached to a node to make it available for pickup.
# If a node needs other scripts, create a subnode to the item that should be pickable.
extends Node3D

@export var item_name: String = "Generic Item"

# Placement relative to the camera while held.
# x = left/right, y = up/down, z = depth (negative pulls toward the camera)
@export var hold_offset: Vector3 = Vector3(0, 0, -2)

# Flip the mesh 180° around Y while held if its front face is away from the camera
@export var flip_y_when_held: bool = true

# Extra rotation (degrees) applied to the mesh while held to make it sit flat
@export var held_rotation_degrees: Vector3 = Vector3(90, 0, 0)

# Safety margin beyond the near plane to avoid clipping
@export var near_margin: float = 0.02

var is_held: bool = false

# Previous placement for restoring on drop
var _prev_parent: Node = null
var _prev_index: int = -1
var _prev_global: Transform3D
var _orig_scale: Vector3 = Vector3.ONE

# Physics references
@onready var _static_body: StaticBody3D = get_node_or_null("StaticBody3D")
var _saved_layer: int = 0
var _saved_mask: int = 0

# All CollisionShape3D under this item
var _colliders: Array = []
var _colliders_prev_disabled: Array = []

# First mesh (for bounds/orientation)
@onready var _mesh: MeshInstance3D = _find_first_mesh(self)
var _mesh_prev_xform: Transform3D

# Track whether this node was already top-level before dragging
var _was_top_level: bool = false

# ------------------------------------------------
# Drag and Drop pickup logic
# ------------------------------------------------

## Begins a table-drag hold without reparenting under the camera.
## Disables physics & stores original placement, similar to pickup(), but does NOT move it in front of the camera.
func start_drag() -> void:
	if is_held:
		return
	is_held = true

	# Remember placement
	_prev_parent = get_parent()
	_prev_index  = get_index()
	_prev_global = global_transform
	_orig_scale  = scale

	# Do NOT set_as_top_level(true). Keep the hierarchy intact.

	# Disable collisions while dragging so the item doesn't fight the table
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


## Updates world position while dragging on the table.
func update_drag(world_pos: Vector3) -> void:
	if not is_held:
		return
	visible = true
	if _mesh: _mesh.visible = true   # <- force the first mesh on
	var xf := global_transform
	xf.origin = world_pos
	global_transform = xf

## Ends drag, keeps current transform.
func end_drag() -> void:
	if not is_held:
		return
	is_held = false

	# Restore the original parent container
	# but keep the transform from the drag
	if _prev_parent:
		var xf := global_transform          # save current dragged transform
		_prev_parent.add_child(self)        # reattach to the old parent
		_prev_parent.move_child(self, _prev_index)
		global_transform = xf               # reapply current transform

	# Restore the original scale (if the item was resized while held).
	scale = _orig_scale

	# Re-enable physics collisions for the StaticBody3D.
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask = _saved_mask

	# Re-enable individual collision shapes that were disabled during drag.
	for i in _colliders.size():
		_colliders[i].disabled = _colliders_prev_disabled[i]

	# --- Snap flat on table ---
	# Cast a ray straight down from slightly above the item to detect the table surface.
	var space_state = get_world_3d().direct_space_state
	var from_pos = global_transform.origin + Vector3(0, 2, 0)   # start ray 2 units above
	var to_pos   = global_transform.origin + Vector3(0, -5, 0)  # end ray 5 units below

	var params = PhysicsRayQueryParameters3D.create(from_pos, to_pos)
	var result = space_state.intersect_ray(params)

	if result.has("position"):
		var hit = result.position   # the world-space point where the ray hit

		# Calculate how far the object's bottom is from its origin
		# so we can rest it flush on the surface.
		var bottom_offset := 0.0
		if _mesh:
			var aabb = _mesh.get_aabb()
			bottom_offset = aabb.position.y * scale.y

		# Move the item so its bottom sits exactly on the hit point.
		var xf = global_transform
		xf.origin = hit - Vector3(0, bottom_offset, 0)
		global_transform = xf

		# Force the object to lie flat (clear tilt).
		rotation_degrees.x = 0
		rotation_degrees.z = 0

# ------------------------------------------------
# Old logic to view the item in front of the camera
# Maybe we can keep some of this code for later use to inspect an item
# TODO: Check what we should keep when implementing the inspect feature
# ------------------------------------------------

## Picks up the item:
## - stores original parent/index/global transform/scale
## - prepares mesh orientation to face the camera
## - disables physics interactions (layers and shapes)
## - defers reparenting and placement to next idle frame to avoid a physics bump
func pickup(player: Node):
	if is_held:
		return
	is_held = true

	var cam: Camera3D = player.get_node("Camera3D")
	var hold_point: Node3D = player.get_node("Camera3D/HoldPoint")

	# Save original placement
	_prev_parent = get_parent()
	_prev_index = get_index()
	_prev_global = global_transform
	_orig_scale = scale

	# Save mesh local transform, then zero its rotation to make it face-flat
	if _mesh:
		_mesh_prev_xform = _mesh.transform
		_mesh.transform = Transform3D.IDENTITY
		if held_rotation_degrees != Vector3.ZERO:
			_mesh.rotate_x(deg_to_rad(held_rotation_degrees.x))
			_mesh.rotate_y(deg_to_rad(held_rotation_degrees.y))
			_mesh.rotate_z(deg_to_rad(held_rotation_degrees.z))
		if flip_y_when_held:
			_mesh.rotate_y(PI)

	# Disable physics interactions while held
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

	# Defer reparenting and placement to the idle step so physics changes apply first
	call_deferred("_finish_pickup", cam, hold_point)

## Completes pickup on the idle frame:
## - reparents under the camera hold point, preserving global
## - resets local transform and reapplies original scale
## - computes a safe distance using a world-space bound so the whole item is beyond the near plane
## - applies the configured offset to place it centered in view
func _finish_pickup(cam: Camera3D, hold_point: Node3D) -> void:
	# Reparent under camera and align root exactly with camera
	reparent(hold_point, false)
	transform = Transform3D.IDENTITY
	scale = _orig_scale

	# Compute a safe offset so the whole object clears the near plane
	var radius := _approx_world_radius()
	var offset := hold_offset
	var min_dist := cam.near + radius + near_margin
	if -offset.z < min_dist:
		offset.z = -min_dist

	# Place centered in front of the camera
	translate_object_local(offset)

## Drops the item:
## - reparents to the previous parent if valid, otherwise the scene root
## - restores the original global transform and mesh transform
## - restores physics layers and re-enables all collision shapes
func drop(_player: Node):
	if not is_held:
		return

	# Restore parent or fall back to the scene root
	var world: Node = get_tree().current_scene
	var target_parent: Node = _prev_parent
	if target_parent == null or not is_instance_valid(target_parent):
		target_parent = world

	reparent(target_parent, true)
	global_transform = _prev_global

	# Restore mesh transform
	if _mesh:
		_mesh.transform = _mesh_prev_xform

	# Re-enable physics
	if _static_body:
		_static_body.collision_layer = _saved_layer
		_static_body.collision_mask  = _saved_mask
	for i in range(_colliders.size()):
		var cs: CollisionShape3D = _colliders[i]
		if is_instance_valid(cs):
			cs.disabled = bool(_colliders_prev_disabled[i])

	is_held = false

## Recursively gathers all CollisionShape3D descendants under the given node.
func _collect_collision_shapes(n: Node) -> Array:
	var out: Array = []
	for c in n.get_children():
		if c is CollisionShape3D:
			out.append(c)
		out.append_array(_collect_collision_shapes(c))
	return out

## Returns the first MeshInstance3D found in a depth-first search starting at the given node.
## Used for computing bounds and adjusting orientation while held.
func _find_first_mesh(n: Node) -> MeshInstance3D:
	if n is MeshInstance3D:
		return n
	for c in n.get_children():
		var m := _find_first_mesh(c)
		if m:
			return m
	return null

## Approximates a world-space bounding sphere radius for all meshes under this item.
## Uses each mesh's local AABB scaled by the current global scale and takes the largest result.
func _approx_world_radius() -> float:
	var max_r := 0.0
	var meshes := _collect_meshes(self)
	for m in meshes:
		var aabb: AABB = m.get_aabb()
		var gscale: Vector3 = global_transform.basis.get_scale().abs()
		var size_world: Vector3 = Vector3(
			aabb.size.x * gscale.x,
			aabb.size.y * gscale.y,
			aabb.size.z * gscale.z
		)
		max_r = max(max_r, size_world.length() * 0.5)
	return max_r

## Recursively collects all MeshInstance3D descendants under the given node.
func _collect_meshes(n: Node) -> Array:
	var out: Array = []
	if n is MeshInstance3D:
		out.append(n)
	for c in n.get_children():
		out.append_array(_collect_meshes(c))
	return out
