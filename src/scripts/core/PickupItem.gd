class_name PickupItem
extends RigidBody3D

## Rotation of object when held
@export var held_rotation: Vector3 = Vector3.ZERO
## Should pick be a toggle action or a held action
@export var pick_toggle: bool = false
## Should the mouse be hidden when object is held
@export var hide_mouse: bool = false
## Use a fixed anchor point instead of click position (in local space)
@export var use_fixed_anchor: bool = false
## Fixed anchor point in local coordinates (e.g., Vector3(0, -0.05, 0) for pen tip)
@export var anchor_offset: Vector3 = Vector3.ZERO

@export_group("Drop logic")
## Snap back to origin position on drop
@export var snap_to_origin_position: bool = false
## Snap back to origin rotation on drop
@export var snap_to_origin_rotation: bool = false

@export_group("Inspect")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var inspect_enabled: bool = false
## Local offset from the camera (Godot forward is -Z)
@export var inspect_offset: Vector3 = Vector3(-0.2, 0, -0.2)
## Rotation relative to camera (degrees)
@export var inspect_rotation: Vector3 = Vector3.ZERO
## Higher = snappier follow in inspect (0 = teleport)
@export var inspect_smooth: float = 14.0

@export_group("Document Input")
## Viewport to forward clicks to (for interactive documents)
@export var document_viewport: SubViewport
## Size of the document viewport for coordinate mapping
@export var document_viewport_size := Vector2(2048, 2048)

var origin_position: Vector3
var origin_rotation: Vector3
var _pre_pick_freeze := false

var _inspecting := false
var _inspect_camera: Camera3D
var _pre_inspect_transform: Transform3D


## Get the grab offset for this item.
## If use_fixed_anchor is true, returns anchor_offset.
## Otherwise, returns the offset based on where the item was clicked.
## [param hit_position] World position where the item was clicked.
## [return] Local offset for grabbing.
func get_grab_offset(hit_position: Vector3) -> Vector3:
	if use_fixed_anchor:
		return anchor_offset
	else:
		return to_local(hit_position)


func _ready():
	collision_layer = 2
	origin_position = global_transform.origin
	origin_rotation = global_rotation


## Runs on pickup
func on_pickup() -> void:
	_pre_pick_freeze = freeze
	freeze = true
	global_rotation_degrees = held_rotation
	if hide_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


## Runs on drop
func on_drop() -> void:
	if snap_to_origin_position:
		global_transform.origin = origin_position
		if snap_to_origin_rotation:
			global_rotation = origin_rotation
		freeze = true
	elif snap_to_origin_rotation:
		global_rotation = origin_rotation
		freeze = false
	else:
		freeze = false

	if hide_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


## Runs on inspect start
func start_inspect(camera: Camera3D) -> void:
	if _inspecting:
		return
	_inspecting = true
	_inspect_camera = camera
	_pre_inspect_transform = global_transform
	freeze = true


## Runs on inspect close
func end_inspect() -> void:
	if not _inspecting:
		return
	_inspecting = false
	_inspect_camera = null
	global_rotation_degrees = held_rotation


func toggle_inspect(camera: Camera3D) -> void:
	if _inspecting:
		end_inspect()
	else:
		start_inspect(camera)


func is_inspecting() -> bool:
	return _inspecting


func handle_inspect_input(event: InputEvent) -> bool:
	if not _inspecting:
		return false

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		end_inspect()
		return true

	if event is InputEventMouseButton and event.pressed:
		if not event.button_index == MOUSE_BUTTON_RIGHT:
			return false
		if _inspect_camera == null or not is_instance_valid(_inspect_camera):
			end_inspect()
			return true
		var mouse_pos: Vector2 = event.position
		var from := _inspect_camera.project_ray_origin(mouse_pos)
		var dir := _inspect_camera.project_ray_normal(mouse_pos)
		var to := from + dir * 10_000.0

		var space := _inspect_camera.get_world_3d().direct_space_state
		var params := PhysicsRayQueryParameters3D.create(from, to)
		params.collide_with_bodies = true
		params.collide_with_areas = true
		var hit := space.intersect_ray(params)

		var clicked_self := false
		if hit.size() > 0:
			var col: Variant = hit.collider
			if col is Node:
				clicked_self = (col == self) or self.is_ancestor_of(col)
		if not clicked_self:
			end_inspect()
		return true

	return false


func _process(delta: float) -> void:
	if not _inspecting or _inspect_camera == null or not is_instance_valid(_inspect_camera):
		return

	var cam_t: Transform3D = _inspect_camera.global_transform
	var target_t := cam_t * Transform3D(Basis(), inspect_offset)

	var local_rot_rad := inspect_rotation * deg_to_rad(1.0)
	var rel_basis := Basis.from_euler(local_rot_rad)
	target_t.basis = cam_t.basis * rel_basis

	if inspect_smooth > 0.0:
		var a: float = clamp(inspect_smooth * delta, 0.0, 1.0)
		global_transform.origin = global_transform.origin.lerp(target_t.origin, a)
		var q_from := global_transform.basis.get_rotation_quaternion()
		var q_to := target_t.basis.get_rotation_quaternion()
		global_transform.basis = Basis(q_from.slerp(q_to, a))
	else:
		global_transform = target_t


## Handle input events on this object (for document interaction)
func _input_event(_camera: Camera3D, event: InputEvent, click_position: Vector3, _click_normal: Vector3, _shape_idx: int) -> void:
	# Only forward to document viewport if set
	if not document_viewport:
		return

	# Only handle mouse button events
	if not event is InputEventMouseButton:
		return

	var mouse_event := event as InputEventMouseButton

	# Get UV coordinates at click position
	var uv := _get_document_uv(click_position)
	if uv == Vector2(-1, -1):
		return

	# Convert UV (0-1 range) to viewport pixel coordinates
	var viewport_pos := uv * document_viewport_size

	# Create new mouse event with viewport coordinates
	var viewport_event := InputEventMouseButton.new()
	viewport_event.button_index = mouse_event.button_index
	viewport_event.pressed = mouse_event.pressed
	viewport_event.position = viewport_pos
	viewport_event.global_position = viewport_pos

	# Push event to viewport
	document_viewport.push_input(viewport_event)


## Get UV coordinates at a 3D position on the document mesh
func _get_document_uv(pos: Vector3) -> Vector2:
	# Find the mesh instance
	var mesh_instance: MeshInstance3D = null
	for child in get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			break

	if not mesh_instance:
		return Vector2(-1, -1)

	# Convert 3D position to local mesh space
	var local_pos := mesh_instance.to_local(pos)

	# For a plane mesh, UV coordinates map directly to local XZ position
	var mesh := mesh_instance.mesh
	if mesh is PlaneMesh:
		var plane_size: Vector2 = mesh.size

		# Normalize position to 0-1 range
		var u := (local_pos.x / plane_size.x) + 0.5
		var v := (local_pos.z / plane_size.y) + 0.5

		# Clamp to valid range
		u = clampf(u, 0.0, 1.0)
		v = clampf(v, 0.0, 1.0)

		return Vector2(u, v)

	return Vector2(-1, -1)
