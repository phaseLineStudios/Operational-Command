class_name PickupItem
extends RigidBody3D

## Surface index 3 is the paper surface on the clipboard
const PAPER_SURFACE_INDEX := 3

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

	if document_viewport:
		set_process_unhandled_input(true)


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
	global_transform = _pre_inspect_transform
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
		if event.button_index == MOUSE_BUTTON_LEFT and document_viewport:
			var mouse_event := event as InputEventMouseButton
			if _inspect_camera == null or not is_instance_valid(_inspect_camera):
				return false

			var mouse_pos: Vector2 = mouse_event.position
			var from := _inspect_camera.project_ray_origin(mouse_pos)
			var dir := _inspect_camera.project_ray_normal(mouse_pos)
			var to := from + dir * 10_000.0

			var space := _inspect_camera.get_world_3d().direct_space_state
			var params := PhysicsRayQueryParameters3D.create(from, to)
			params.collide_with_bodies = true
			params.collision_mask = collision_layer
			var hit := space.intersect_ray(params)

			if hit.is_empty() or hit.collider != self:
				end_inspect()
				return true

			var uv := _get_document_uv_from_hit(hit)
			if uv != Vector2(-1, -1):
				var viewport_pos := uv * document_viewport_size

				var viewport_event := InputEventMouseButton.new()
				viewport_event.button_index = mouse_event.button_index
				viewport_event.pressed = mouse_event.pressed
				viewport_event.position = viewport_pos
				viewport_event.global_position = viewport_pos
				document_viewport.push_input(viewport_event)
				return true

		# Handle right clicks for closing inspect
		if event.button_index == MOUSE_BUTTON_RIGHT:
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


## Handle unhandled input for document interaction
func _unhandled_input(event: InputEvent) -> void:
	if not document_viewport:
		return

	# Only handle mouse button clicks while inspecting
	if not _inspecting:
		return

	if not event is InputEventMouseButton:
		return

	var mouse_event := event as InputEventMouseButton

	# Only handle left clicks
	if mouse_event.button_index != MOUSE_BUTTON_LEFT:
		return

	var camera := get_viewport().get_camera_3d()
	if not camera:
		return
	var mouse_pos := mouse_event.position
	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)
	var to := from + dir * 1000.0

	var space := get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.collide_with_bodies = true
	params.collision_mask = collision_layer
	var hit := space.intersect_ray(params)

	if hit.is_empty() or hit.collider != self:
		return

	var uv := _get_document_uv_from_hit(hit)
	if uv == Vector2(-1, -1):
		return

	var viewport_pos := uv * document_viewport_size

	var viewport_event := InputEventMouseButton.new()
	viewport_event.button_index = mouse_event.button_index
	viewport_event.pressed = mouse_event.pressed
	viewport_event.position = viewport_pos
	viewport_event.global_position = viewport_pos
	document_viewport.push_input(viewport_event)

	get_viewport().set_input_as_handled()


## Get UV coordinates from raycast hit on document mesh
func _get_document_uv_from_hit(hit: Dictionary) -> Vector2:
	if not hit.has("face_index"):
		return Vector2(-1, -1)

	var mesh_node := get_node_or_null("Mesh")
	if not mesh_node:
		return Vector2(-1, -1)

	var mesh_instance: MeshInstance3D = null
	for child in mesh_node.get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			break

	if not mesh_instance:
		return Vector2(-1, -1)

	var mesh := mesh_instance.mesh
	if not mesh is ArrayMesh:
		return Vector2(-1, -1)

	if mesh.get_surface_count() <= PAPER_SURFACE_INDEX:
		return Vector2(-1, -1)

	var arrays := mesh.surface_get_arrays(PAPER_SURFACE_INDEX)
	if arrays.size() == 0:
		return Vector2(-1, -1)

	var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	var uvs: PackedVector2Array = arrays[Mesh.ARRAY_TEX_UV]
	var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]

	if vertices.size() == 0 or uvs.size() == 0:
		return Vector2(-1, -1)

	var face_index: int = hit.face_index
	var i0: int
	var i1: int
	var i2: int

	if indices.size() > 0:
		if face_index * 3 + 2 >= indices.size():
			return Vector2(-1, -1)
		i0 = indices[face_index * 3]
		i1 = indices[face_index * 3 + 1]
		i2 = indices[face_index * 3 + 2]
	else:
		i0 = face_index * 3
		i1 = face_index * 3 + 1
		i2 = face_index * 3 + 2

	if i0 >= vertices.size() or i1 >= vertices.size() or i2 >= vertices.size():
		return Vector2(-1, -1)

	var v0 := mesh_instance.to_global(vertices[i0])
	var v1 := mesh_instance.to_global(vertices[i1])
	var v2 := mesh_instance.to_global(vertices[i2])

	var hit_pos: Vector3 = hit.position
	var bary := _barycentric_coords(hit_pos, v0, v1, v2)

	var uv0 := uvs[i0]
	var uv1 := uvs[i1]
	var uv2 := uvs[i2]

	var uv := uv0 * bary.x + uv1 * bary.y + uv2 * bary.z
	return uv


## Calculate barycentric coordinates of point p in triangle (a, b, c)
func _barycentric_coords(p: Vector3, a: Vector3, b: Vector3, c: Vector3) -> Vector3:
	var v0 := b - a
	var v1 := c - a
	var v2 := p - a

	var d00 := v0.dot(v0)
	var d01 := v0.dot(v1)
	var d11 := v1.dot(v1)
	var d20 := v2.dot(v0)
	var d21 := v2.dot(v1)

	var denom := d00 * d11 - d01 * d01
	if abs(denom) < 0.0001:
		return Vector3(1, 0, 0)  # Degenerate triangle

	var v := (d11 * d20 - d01 * d21) / denom
	var w := (d00 * d21 - d01 * d20) / denom
	var u := 1.0 - v - w

	return Vector3(u, v, w)
