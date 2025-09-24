extends Node
class_name TableCamera

@export var move_speed: float = 12.0
@export var z_tilt_min_deg: float = 15.0
@export var z_tilt_max_deg: float = 55.0
@export var tilt_smooth: float = 10.0

@onready var bounds: MeshInstance3D = $CameraBounds
@onready var camera: Camera3D = $CameraBounds/Camera

var _half_x := 0.0
var _half_z := 0.0
var _target_tilt_rad := 0.0

func _ready():
	bounds.transparency = 1

	_half_x = bounds.mesh.size.x * 0.5
	_half_z = bounds.mesh.size.y * 0.5
	
	camera.global_position.y = bounds.position.y
	_clamp_to_bounds()
	
	_update_target_tilt_from_z()
	camera.rotation_degrees.x = rad_to_deg(_target_tilt_rad)

func _physics_process(delta: float) -> void:
	var input_vec := Vector2.ZERO
	input_vec.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_vec.y = int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
	if input_vec.length() > 0.0:
		input_vec = input_vec.normalized()
	
	var vel := Vector3(input_vec.x * move_speed, 0.0, input_vec.y * move_speed)
	camera.global_position += vel * delta
	
	camera.global_position.y = bounds.position.y
	_clamp_to_bounds()
	
	_update_target_tilt_from_z()
	
	var new_x: float = lerp(camera.rotation.x, _target_tilt_rad, clamp(tilt_smooth * delta, 0.0, 1.0))
	camera.rotation.x = new_x

## Clamp Camera position to bounds
func _clamp_to_bounds() -> void:
	var cx := bounds.position.x
	var cz := bounds.position.z
	camera.global_position.x = clamp(camera.global_position.x, cx - _half_x, cx + _half_x)
	camera.global_position.z = clamp(camera.global_position.z, cz - _half_z, cz + _half_z)

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
