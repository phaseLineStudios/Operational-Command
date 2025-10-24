class_name TimerController
extends Node
## Controls simulation time via clickable buttons on the timer model.
##
## Detects clicks on three buttons (pause, 1x speed, 2x speed) and animates
## them while controlling the Engine.time_scale.

## Reference to the Timer object.
@export var timer: Node3D
## Reference to the SimWorld for pause/resume control.
@export var sim_world: SimWorld
## Camera used for raycasting.
@export var camera: Camera3D
## Collision layer for button detection.
@export var button_mask: int = 4
## Bone Name for the pause button.
@export var pause_button_bone: String = "Button.Pause"
## Bone Name for the play button.
@export var speed_1x_button_bone: String = "Button.Play"
## Bone Name for the speed button.
@export var speed_2x_button_bone: String = "Button.Speed"

## Animation parameter for how far the button depresses.
@export var press_depth: float = 0.01
## Animation parameter for duration of animation.
@export var press_duration: float = 0.1

## Button Collision box size.
@export var collision_box_size: Vector3 = Vector3(0.08, 0.015, 0.15)
## Button Collision box position.
@export var collision_box_position: Vector3 = Vector3(0, 0.6, 0)

## Enable debug visualization of collision box.
@export var debug_draw_collision: bool = false

@export_group("LCD Display")
## Surface material override index for LCD.
@export var lcd_surface_index: int = 1
## Display resolution.
@export var lcd_resolution: Vector2i = Vector2i(256, 91)
## Display background color.
@export var lcd_bg_color: Color = Color(0.054, 0.0, 0.004, 1.0)
## Display text color.
@export var lcd_text_color: Color = Color(1.0, 0.645, 0.613, 1.0)
## Display font.
@export var lcd_font: FontFile
## Display font size.
@export var lcd_font_size: int = 24
## Letter spacing (kerning) - negative values tighten, positive values loosen.
@export var lcd_letter_spacing: int = 0
## Icon texture for pause state.
@export var pause_icon: Texture2D
## Icon texture for play/1x speed state.
@export var play_icon: Texture2D
## Icon texture for fast-forward/2x speed state.
@export var fastforward_icon: Texture2D
## Icon size on display.
@export var icon_size: Vector2 = Vector2(32, 32)

enum TimeState { PAUSED, SPEED_1X, SPEED_2X }

var _current_state := TimeState.PAUSED
var _skeleton: Skeleton3D
var _pause_bone_idx: int = -1
var _speed_1x_bone_idx: int = -1
var _speed_2x_bone_idx: int = -1
var _animating_bones: Dictionary = {}  # bone_idx -> {target_y, duration, elapsed}
var _debug_mesh: MeshInstance3D
var _current_pressed_bone: int = -1  # Currently depressed button bone
var _bone_rest_positions: Dictionary = {}  # bone_idx -> original_y
var _lcd_viewport: SubViewport
var _lcd_label: Label
var _lcd_icon: TextureRect
var _sim_elapsed_time: float = 0.0  # Accumulated simulation time


func _ready() -> void:
	# Setup collision body for button clicks
	_setup_collision()

	# Setup LCD display
	_setup_lcd_display()

	# Find skeleton in children
	_skeleton = _find_skeleton(timer)
	if _skeleton == null:
		push_warning("TimerController: No Skeleton3D found in Timer model")
		return

	# Get bone indices
	_pause_bone_idx = _skeleton.find_bone(pause_button_bone)
	_speed_1x_bone_idx = _skeleton.find_bone(speed_1x_button_bone)
	_speed_2x_bone_idx = _skeleton.find_bone(speed_2x_button_bone)

	if _pause_bone_idx == -1:
		push_warning("TimerController: Bone '%s' not found" % pause_button_bone)
	if _speed_1x_bone_idx == -1:
		push_warning("TimerController: Bone '%s' not found" % speed_1x_button_bone)
	if _speed_2x_bone_idx == -1:
		push_warning("TimerController: Bone '%s' not found" % speed_2x_button_bone)

	# Store rest positions for all buttons
	for bone_idx in [_pause_bone_idx, _speed_1x_bone_idx, _speed_2x_bone_idx]:
		if bone_idx >= 0:
			var pose := _skeleton.get_bone_pose(bone_idx)
			_bone_rest_positions[bone_idx] = pose.origin.y

	# Set initial time scale and button state
	_apply_time_state(_current_state)
	_set_button_pressed(_get_bone_for_state(_current_state))


## Setup collision body for button click detection.
func _setup_collision() -> void:
	if timer == null:
		push_warning("TimerController: Timer reference not set")
		return

	var static_body := StaticBody3D.new()
	static_body.collision_layer = button_mask
	static_body.collision_mask = 0
	timer.add_child(static_body)

	var collision_shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = collision_box_size
	collision_shape.shape = box_shape
	collision_shape.position = collision_box_position
	static_body.add_child(collision_shape)

	# Setup debug visualization if enabled
	if debug_draw_collision:
		_setup_debug_draw(static_body)


func _process(delta: float) -> void:
	# Accumulate simulation time based on current state
	if _current_state == TimeState.PAUSED:
		# Time is paused, don't accumulate
		pass
	elif _current_state == TimeState.SPEED_1X:
		_sim_elapsed_time += delta
	elif _current_state == TimeState.SPEED_2X:
		_sim_elapsed_time += delta * 2.0

	# Update LCD display
	_update_lcd_display()

	# Animate button presses
	if _skeleton == null:
		return

	for bone_idx in _animating_bones.keys():
		var anim: Dictionary = _animating_bones[bone_idx]
		anim.elapsed += delta

		var t := clampf(anim.elapsed / anim.duration, 0.0, 1.0)
		# Ease out for smooth animation
		var eased := 1.0 - pow(1.0 - t, 3.0)

		var current_pose := _skeleton.get_bone_pose(bone_idx)
		var start_y: float = anim.get("start_y", 0.0)
		var target_y: float = anim.target_y
		current_pose.origin.y = lerpf(start_y, target_y, eased)
		_skeleton.set_bone_pose(bone_idx, current_pose)

		if t >= 1.0:
			_animating_bones.erase(bone_idx)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_check_button_click(event.position)


## Check if a button was clicked and handle it.
func _check_button_click(mouse_pos: Vector2) -> void:
	if camera == null or _skeleton == null:
		return

	var from := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)
	var to := from + dir * 10_000.0

	var space := camera.get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.create(from, to)
	params.collision_mask = button_mask
	params.collide_with_bodies = true
	params.collide_with_areas = true

	var hit := space.intersect_ray(params)
	if hit.is_empty():
		return

	# Check if we hit this timer object
	var collider: Node = hit.collider
	if not _is_child_of_timer(collider):
		return

	# Determine which button was clicked based on hit position
	var hit_local := timer.to_local(hit.position)
	var clicked_bone := _get_closest_button_bone(hit_local)

	if clicked_bone >= 0:
		_on_button_pressed(clicked_bone)
		get_viewport().set_input_as_handled()


## Find which button bone is closest to the click position.
func _get_closest_button_bone(local_pos: Vector3) -> int:
	if _skeleton == null:
		return -1

	var closest_bone := -1
	var closest_dist := INF

	for bone_idx in [_pause_bone_idx, _speed_1x_bone_idx, _speed_2x_bone_idx]:
		if bone_idx < 0:
			continue

		var bone_pose := _skeleton.get_bone_global_pose(bone_idx)
		var bone_world_pos := _skeleton.global_transform * bone_pose.origin
		var bone_local_pos := timer.to_local(bone_world_pos)

		var dist := local_pos.distance_to(bone_local_pos)
		if dist < closest_dist:
			closest_dist = dist
			closest_bone = bone_idx

	# Only consider it a click if reasonably close (within 5cm)
	if closest_dist > 0.05:
		return -1

	return closest_bone


## Handle button press.
func _on_button_pressed(bone_idx: int) -> void:
	# Don't do anything if same button pressed
	if bone_idx == _current_pressed_bone:
		return

	# Release previous button
	if _current_pressed_bone >= 0:
		_release_button(_current_pressed_bone)

	# Press new button (stays down)
	_set_button_pressed(bone_idx)

	# Change time state
	if bone_idx == _pause_bone_idx:
		_set_time_state(TimeState.PAUSED)
	elif bone_idx == _speed_1x_bone_idx:
		_set_time_state(TimeState.SPEED_1X)
	elif bone_idx == _speed_2x_bone_idx:
		_set_time_state(TimeState.SPEED_2X)


## Set a button to pressed state (depressed and stays down).
func _set_button_pressed(bone_idx: int) -> void:
	if _skeleton == null or bone_idx < 0:
		return

	var current_pose := _skeleton.get_bone_pose(bone_idx)
	var start_y := current_pose.origin.y
	var rest_y: float = _bone_rest_positions.get(bone_idx, 0.0)

	# Animate to pressed position
	_animating_bones[bone_idx] = {
		"start_y": start_y,
		"target_y": rest_y - press_depth,
		"duration": press_duration,
		"elapsed": 0.0
	}

	_current_pressed_bone = bone_idx


## Release a button (animate back to rest position).
func _release_button(bone_idx: int) -> void:
	if _skeleton == null or bone_idx < 0:
		return

	var current_pose := _skeleton.get_bone_pose(bone_idx)
	var start_y := current_pose.origin.y
	var rest_y: float = _bone_rest_positions.get(bone_idx, 0.0)

	# Animate back to rest position
	_animating_bones[bone_idx] = {
		"start_y": start_y, "target_y": rest_y, "duration": press_duration, "elapsed": 0.0
	}


## Set the time state and apply it.
func _set_time_state(state: TimeState) -> void:
	if _current_state == state:
		return
	_current_state = state
	_apply_time_state(state)


## Apply the time state to the sim (not the entire engine).
func _apply_time_state(state: TimeState) -> void:
	if not sim_world:
		return

	match state:
		TimeState.PAUSED:
			sim_world.pause()
		TimeState.SPEED_1X:
			sim_world.set_time_scale(1.0)
			sim_world.resume()
		TimeState.SPEED_2X:
			sim_world.set_time_scale(2.0)
			sim_world.resume()


## Check if a node is part of this timer's hierarchy.
func _is_child_of_timer(node: Node) -> bool:
	var current := node
	while current != null:
		if current == timer:
			return true
		current = current.get_parent()
	return false


## Find Skeleton3D in children recursively.
func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var result := _find_skeleton(child)
		if result != null:
			return result
	return null


## Get the bone index for a time state.
func _get_bone_for_state(state: TimeState) -> int:
	match state:
		TimeState.PAUSED:
			return _pause_bone_idx
		TimeState.SPEED_1X:
			return _speed_1x_bone_idx
		TimeState.SPEED_2X:
			return _speed_2x_bone_idx
	return -1


## Setup debug visualization of collision box.
func _setup_debug_draw(static_body: StaticBody3D) -> void:
	_debug_mesh = MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = collision_box_size
	_debug_mesh.mesh = box_mesh

	# Create transparent material
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.0, 1.0, 0.0, 0.3)  # Green with transparency
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Draw both sides
	_debug_mesh.material_override = material

	_debug_mesh.position = collision_box_position
	static_body.add_child(_debug_mesh)


## Setup LCD display using SubViewport.
func _setup_lcd_display() -> void:
	if timer == null:
		push_warning("TimerController: Timer reference not set for LCD")
		return

	# Find the MeshInstance3D in the timer
	var mesh_instance := _find_mesh_instance(timer)
	if mesh_instance == null:
		push_warning("TimerController: No MeshInstance3D found for LCD display")
		return

	# Create SubViewport for rendering LCD content
	_lcd_viewport = SubViewport.new()
	_lcd_viewport.size = lcd_resolution
	_lcd_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_lcd_viewport.transparent_bg = false
	add_child(_lcd_viewport)

	# Create background ColorRect
	var bg := ColorRect.new()
	bg.color = lcd_bg_color
	bg.size = Vector2(lcd_resolution)
	_lcd_viewport.add_child(bg)

	# Create label for time display (left side)
	_lcd_label = Label.new()

	# Use LabelSettings for better controld
	var label_settings := LabelSettings.new()
	label_settings.font = lcd_font
	label_settings.font_size = lcd_font_size
	label_settings.font_color = lcd_text_color

	# Apply letter spacing if supported by font variation
	if lcd_letter_spacing != 0 and lcd_font:
		# Create a font variation with spacing adjustment
		var font_variation := FontVariation.new()
		font_variation.base_font = lcd_font
		font_variation.spacing_glyph = lcd_letter_spacing
		label_settings.font = font_variation

	_lcd_label.label_settings = label_settings
	_lcd_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_lcd_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_lcd_label.position = Vector2(35, 5)
	_lcd_label.size = Vector2(lcd_resolution.x - 60, lcd_resolution.y - 10)
	_lcd_viewport.add_child(_lcd_label)

	# Create icon display (right side)
	_lcd_icon = TextureRect.new()
	_lcd_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_lcd_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_lcd_icon.modulate = lcd_text_color  # Tint icon to match text color
	_lcd_icon.size = icon_size
	# Position at top right with 5px margin
	_lcd_icon.position = Vector2(lcd_resolution.x - icon_size.x - 15, 0)
	_lcd_viewport.add_child(_lcd_icon)

	# Create material using viewport texture
	var lcd_material := StandardMaterial3D.new()
	var viewport_tex := _lcd_viewport.get_texture()
	lcd_material.albedo_texture = viewport_tex
	lcd_material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	lcd_material.uv1_scale = Vector3(1.0, 1.0, 1.0)
	lcd_material.emission_enabled = true
	lcd_material.emission_texture = viewport_tex
	lcd_material.emission_energy_multiplier = 2.0
	lcd_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	# Apply to surface
	mesh_instance.set_surface_override_material(lcd_surface_index, lcd_material)


## Update LCD display with current time and mode.
func _update_lcd_display() -> void:
	if _lcd_label == null or _lcd_icon == null:
		return

	# Use accumulated simulation time
	var elapsed := _sim_elapsed_time

	# Format time as MM:SS
	var minutes := int(elapsed / 60.0)
	var seconds := int(elapsed) % 60
	var time_str := "%02d:%02d" % [minutes, seconds]

	# Update time label
	_lcd_label.text = time_str

	# Update icon based on current state
	match _current_state:
		TimeState.PAUSED:
			_lcd_icon.texture = pause_icon
		TimeState.SPEED_1X:
			_lcd_icon.texture = play_icon
		TimeState.SPEED_2X:
			_lcd_icon.texture = fastforward_icon


## Find MeshInstance3D in children recursively.
func _find_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result := _find_mesh_instance(child)
		if result != null:
			return result
	return null
