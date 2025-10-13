class_name TableCamera
extends Node

## Camera movement speed
@export var move_speed: Vector2 = Vector2(12.0, 12.0)
## Camera movement smoothing
@export var move_smooth: float = 10.0
## Camera minimum tilt angle in degrees
@export var z_tilt_min_deg: float = 15.0
## Camera maximum tilt angle in degrees
@export var z_tilt_max_deg: float = 55.0
## Camera tilt smoothing
@export var tilt_smooth: float = 10.0

var _half_x := 0.0
var _half_z := 0.0
var _target_tilt_rad := 0.0
var _target_pos := Vector3.ZERO

@onready var bounds: MeshInstance3D = $CameraBounds
@onready var camera: Camera3D = $CameraBounds/Camera


func _ready():
	bounds.transparency = 1

	_half_x = bounds.mesh.size.x * 0.5
	_half_z = bounds.mesh.size.y * 0.5

	camera.global_position.y = bounds.position.y
	_clamp_to_bounds()

	_target_pos = camera.global_position

	_update_target_tilt_from_z()
	camera.rotation_degrees.x = rad_to_deg(_target_tilt_rad)


func _physics_process(delta: float) -> void:
	var input_vec := Vector2.ZERO
	input_vec.x = (
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	)
	input_vec.y = (
		int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
	)
	if input_vec.length() > 0.0:
		input_vec = input_vec.normalized()

	var step2: Vector2 = input_vec * move_speed * delta
	_target_pos += Vector3(step2.x, 0.0, step2.y)
	_target_pos.y = bounds.position.y
	_target_pos = _clamp_vec3_to_bounds(_target_pos)

	camera.global_position = _damp_vec3(camera.global_position, _target_pos, move_smooth, delta)

	_clamp_to_bounds()

	_update_target_tilt_from_z()

	var new_x := _damp_scalar(camera.rotation.x, _target_tilt_rad, tilt_smooth, delta)
	camera.rotation.x = new_x


## Clamp Camera position to bounds
func _clamp_to_bounds() -> void:
	var cx := bounds.position.x
	var cz := bounds.position.z
	camera.global_position.x = clamp(camera.global_position.x, cx - _half_x, cx + _half_x)
	camera.global_position.z = clamp(camera.global_position.z, cz - _half_z, cz + _half_z)


## Clamp an arbitrary position to bounds
func _clamp_vec3_to_bounds(p: Vector3) -> Vector3:
	var cx := bounds.position.x
	var cz := bounds.position.z
	p.x = clamp(p.x, cx - _half_x, cx + _half_x)
	p.z = clamp(p.z, cz - _half_z, cz + _half_z)
	return p


## Update camera tilt
func _update_target_tilt_from_z() -> void:
	var cz := bounds.position.z
	if _half_z <= 0.0:
		_target_tilt_rad = deg_to_rad(z_tilt_min_deg)
		return
	var z_min := cz - _half_z
	var z_max := cz + _half_z
	var t: float = clamp((camera.global_position.z - z_min) / (z_max - z_min), 0.0, 1.0)
	var target_deg: float = lerp(z_tilt_min_deg, z_tilt_max_deg, t)
	_target_tilt_rad = deg_to_rad(target_deg)


## Exponential damping for vectors
static func _damp_vec3(a: Vector3, b: Vector3, k: float, dt: float) -> Vector3:
	if k <= 0.0 or dt <= 0.0:
		return b
	var t := 1.0 - exp(-k * dt)
	return a.lerp(b, clamp(t, 0.0, 1.0))


## Exponential damping for scalars
static func _damp_scalar(a: float, b: float, k: float, dt: float) -> float:
	if k <= 0.0 or dt <= 0.0:
		return b
	var t := 1.0 - exp(-k * dt)
	return lerp(a, b, clamp(t, 0.0, 1.0))
