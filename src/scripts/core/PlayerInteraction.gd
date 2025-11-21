class_name InteractionController
extends Node

@export var pickable_mask: int = 2 << 0
@export var follow_smooth: float = 18.0

var _held: PickupItem = null
var _grab_offset_local := Vector3.ZERO
var _last_valid_plane_point := Vector3.ZERO
var _have_valid_plane_point := false
var _half_x := 0.0
var _half_z := 0.0
var _resume_drag_after_inspect := false

@onready var camera: Camera3D = %CameraController/CameraBounds/Camera
@onready var bounds: MeshInstance3D = $InteractionBounds


func _ready():
	bounds.transparency = 1
	_half_x = bounds.mesh.size.x * 0.5
	_half_z = bounds.mesh.size.y * 0.5
	add_to_group("interaction_controllers")


func _unhandled_input(event: InputEvent) -> void:
	if _held != null and _held.is_inspecting():
		var handled := _held.handle_inspect_input(event)
		if handled:
			get_viewport().set_input_as_handled()
			if _held != null and not _held.is_inspecting():
				if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
					_resume_drag_after_inspect = true
				elif event is InputEventKey and event.keycode == KEY_ESCAPE:
					_resume_drag_after_inspect = false
					_drop_held()
				else:
					_resume_drag_after_inspect = false
		return

	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			if _held != null and _held.inspect_enabled:
				_held.toggle_inspect(camera)
				get_viewport().set_input_as_handled()
				return
			else:
				_try_pickup(event.position)
				if _held and _held.inspect_enabled:
					_held.start_inspect(camera)
					get_viewport().set_input_as_handled()
					return

		if event.button_index == MOUSE_BUTTON_LEFT and _held == null:
			_try_pickup(event.position)
			if _held:
				get_viewport().set_input_as_handled()
				return
		if event.button_index == MOUSE_BUTTON_RIGHT and _held != null and _held.pick_toggle:
			_drop_held()
			get_viewport().set_input_as_handled()
			return

	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT and _held != null and not _held.pick_toggle:
			if _held.is_inspecting():
				get_viewport().set_input_as_handled()
				return
			if _resume_drag_after_inspect:
				_resume_drag_after_inspect = false
				get_viewport().set_input_as_handled()
				return
			_drop_held()
			get_viewport().set_input_as_handled()
			return


func _process(delta: float) -> void:
	if _held == null:
		return

	if _held.is_inspecting():
		return

	var pos: Variant = _project_mouse_to_finite_plane(get_viewport().get_mouse_position())
	if pos != null:
		_last_valid_plane_point = pos
		_have_valid_plane_point = true

	if _have_valid_plane_point:
		var world_offset := _held.global_transform.basis * _grab_offset_local
		var target := _last_valid_plane_point - world_offset
		if follow_smooth > 0.0:
			_held.global_transform.origin = _held.global_transform.origin.lerp(
				target, clamp(follow_smooth * delta, 0.0, 1.0)
			)
		else:
			_held.global_transform.origin = target


func _try_pickup(mouse_pos: Vector2) -> void:
	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)
	var to := from + dir * 10_000.0

	var space := camera.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.collision_mask = pickable_mask
	params.collide_with_bodies = true
	params.collide_with_areas = true
	var hit := space.intersect_ray(params)
	if hit.size() == 0:
		return

	var col: Node3D = hit.collider
	var node: Node3D = null
	if col is Node3D:
		node = col
	else:
		return

	_held = node
	if _held.has_method("on_pickup"):
		_held.call("on_pickup")

	# Use the item's grab offset method if available, otherwise calculate manually
	if _held.has_method("get_grab_offset"):
		_grab_offset_local = _held.get_grab_offset(hit.position)
	else:
		_grab_offset_local = _held.to_local(hit.position)

	var p: Variant = _project_mouse_to_finite_plane(mouse_pos)
	if p != null:
		_last_valid_plane_point = p
		_have_valid_plane_point = true
		var world_offset := _held.global_transform.basis * _grab_offset_local
		_held.global_transform.origin = p - world_offset
	else:
		_have_valid_plane_point = false


func _drop_held() -> void:
	if _held != null:
		if _held.has_method("on_drop"):
			_held.call("on_drop")
	_held = null
	_have_valid_plane_point = false
	_resume_drag_after_inspect = false


func cancel_hold() -> void:
	if _held != null:
		if _held.is_inspecting():
			_held.end_inspect()
		_drop_held()


func _project_mouse_to_finite_plane(mouse_pos: Vector2) -> Variant:
	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)

	var gt := bounds.global_transform
	var world_point_on_plane := gt.origin
	var world_normal := (gt.basis * Vector3.UP).normalized()

	var denom := world_normal.dot(dir)
	if is_equal_approx(denom, 0.0):
		return null
	var t := world_normal.dot(world_point_on_plane - from) / denom
	if t < 0.0:
		return null
	var hit_world := from + dir * t

	var local := gt.affine_inverse() * hit_world
	if absf(local.y) > 0.01:
		return null
	if absf(local.x) > _half_x or absf(local.z) > _half_z:
		return null

	return hit_world
