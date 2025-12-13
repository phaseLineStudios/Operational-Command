# TimerController Class Reference

*File:* `scripts/core/TimerController.gd`
*Class name:* `TimerController`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name TimerController
extends Node
```

## Brief

Controls simulation time via clickable buttons on the timer model.

## Detailed Description

Detects clicks on three buttons (pause, 1x speed, 2x speed) and animates
them while controlling the Engine.time_scale.

## Public Member Functions

- [`func _ready() -> void`](TimerController/functions/_ready.md)
- [`func _setup_collision() -> void`](TimerController/functions/_setup_collision.md) — Setup collision body for button click detection.
- [`func _process(delta: float) -> void`](TimerController/functions/_process.md)
- [`func _unhandled_input(event: InputEvent) -> void`](TimerController/functions/_unhandled_input.md)
- [`func _check_button_click(mouse_pos: Vector2) -> void`](TimerController/functions/_check_button_click.md) — Check if a button was clicked and handle it.
- [`func _get_closest_button_bone(local_pos: Vector3) -> int`](TimerController/functions/_get_closest_button_bone.md) — Find which button bone is closest to the click position.
- [`func _on_button_pressed(bone_idx: int) -> void`](TimerController/functions/_on_button_pressed.md) — Handle button press.
- [`func _set_button_pressed(bone_idx: int) -> void`](TimerController/functions/_set_button_pressed.md) — Set a button to pressed state (depressed and stays down).
- [`func _release_button(bone_idx: int) -> void`](TimerController/functions/_release_button.md) — Release a button (animate back to rest position).
- [`func _set_time_state(state: TimeState) -> void`](TimerController/functions/_set_time_state.md) — Set the time state and apply it.
- [`func _apply_time_state(state: TimeState) -> void`](TimerController/functions/_apply_time_state.md) — Apply the time state to the sim (not the entire engine).
- [`func _is_child_of_timer(node: Node) -> bool`](TimerController/functions/_is_child_of_timer.md) — Check if a node is part of this timer's hierarchy.
- [`func _find_skeleton(node: Node) -> Skeleton3D`](TimerController/functions/_find_skeleton.md) — Find Skeleton3D in children recursively.
- [`func _get_bone_for_state(state: TimeState) -> int`](TimerController/functions/_get_bone_for_state.md) — Get the bone index for a time state.
- [`func _setup_debug_draw(static_body: StaticBody3D) -> void`](TimerController/functions/_setup_debug_draw.md) — Setup debug visualization of collision box.
- [`func _setup_lcd_display() -> void`](TimerController/functions/_setup_lcd_display.md) — Setup LCD display using SubViewport.
- [`func _update_lcd_display() -> void`](TimerController/functions/_update_lcd_display.md) — Update LCD display with current time and mode.
- [`func _find_mesh_instance(node: Node) -> MeshInstance3D`](TimerController/functions/_find_mesh_instance.md) — Find MeshInstance3D in children recursively.
- [`func _play_button_press_sound() -> void`](TimerController/functions/_play_button_press_sound.md) — Play a random button press sound
- [`func _play_button_release_sound() -> void`](TimerController/functions/_play_button_release_sound.md) — Play a random button release sound

## Public Attributes

- `Node3D timer` — Reference to the Timer object.
- `SimWorld sim_world` — Reference to the SimWorld for pause/resume control.
- `Camera3D camera` — Camera used for raycasting.
- `int button_mask` — Collision layer for button detection.
- `String pause_button_bone` — Bone Name for the pause button.
- `String speed_1x_button_bone` — Bone Name for the play button.
- `String speed_2x_button_bone` — Bone Name for the speed button.
- `float press_depth` — Animation parameter for how far the button depresses.
- `float press_duration` — Animation parameter for duration of animation.
- `Vector3 collision_box_size` — Button Collision box size.
- `Vector3 collision_box_position` — Button Collision box position.
- `bool debug_draw_collision` — Enable debug visualization of collision box.
- `Array[AudioStream] button_press_sounds` — Button press sound effects to play randomly when button is pressed
- `Array[AudioStream] button_release_sounds` — Button release sound effects to play randomly when button is released
- `float button_sound_pitch_variation` — Random pitch variation range (0.0 = no variation, 0.1 = ±10%, etc.)
- `int lcd_surface_index` — Surface material override index for LCD.
- `Vector2i lcd_resolution` — Display resolution.
- `Color lcd_bg_color` — Display background color.
- `Color lcd_text_color` — Display text color.
- `FontFile lcd_font` — Display font.
- `int lcd_font_size` — Display font size.
- `int lcd_letter_spacing` — Letter spacing (kerning) - negative values tighten, positive values loosen.
- `Texture2D pause_icon` — Icon texture for pause state.
- `Texture2D play_icon` — Icon texture for play/1x speed state.
- `Texture2D fastforward_icon` — Icon texture for fast-forward/2x speed state.
- `Vector2 icon_size` — Icon size on display.
- `Skeleton3D _skeleton`
- `int _pause_bone_idx`
- `int _speed_1x_bone_idx`
- `int _speed_2x_bone_idx`
- `Dictionary _animating_bones`
- `MeshInstance3D _debug_mesh`
- `int _current_pressed_bone`
- `Dictionary _bone_rest_positions`
- `SubViewport _lcd_viewport`
- `Label _lcd_label`
- `TextureRect _lcd_icon`
- `float _sim_elapsed_time`
- `AudioStreamPlayer3D _button_sound_player`

## Enumerations

- `enum TimeState` — Time scale state.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _setup_collision

```gdscript
func _setup_collision() -> void
```

Setup collision body for button click detection.

### _process

```gdscript
func _process(delta: float) -> void
```

### _unhandled_input

```gdscript
func _unhandled_input(event: InputEvent) -> void
```

### _check_button_click

```gdscript
func _check_button_click(mouse_pos: Vector2) -> void
```

Check if a button was clicked and handle it.

### _get_closest_button_bone

```gdscript
func _get_closest_button_bone(local_pos: Vector3) -> int
```

Find which button bone is closest to the click position.

### _on_button_pressed

```gdscript
func _on_button_pressed(bone_idx: int) -> void
```

Handle button press.

### _set_button_pressed

```gdscript
func _set_button_pressed(bone_idx: int) -> void
```

Set a button to pressed state (depressed and stays down).

### _release_button

```gdscript
func _release_button(bone_idx: int) -> void
```

Release a button (animate back to rest position).

### _set_time_state

```gdscript
func _set_time_state(state: TimeState) -> void
```

Set the time state and apply it.

### _apply_time_state

```gdscript
func _apply_time_state(state: TimeState) -> void
```

Apply the time state to the sim (not the entire engine).

### _is_child_of_timer

```gdscript
func _is_child_of_timer(node: Node) -> bool
```

Check if a node is part of this timer's hierarchy.

### _find_skeleton

```gdscript
func _find_skeleton(node: Node) -> Skeleton3D
```

Find Skeleton3D in children recursively.

### _get_bone_for_state

```gdscript
func _get_bone_for_state(state: TimeState) -> int
```

Get the bone index for a time state.

### _setup_debug_draw

```gdscript
func _setup_debug_draw(static_body: StaticBody3D) -> void
```

Setup debug visualization of collision box.

### _setup_lcd_display

```gdscript
func _setup_lcd_display() -> void
```

Setup LCD display using SubViewport.

### _update_lcd_display

```gdscript
func _update_lcd_display() -> void
```

Update LCD display with current time and mode.

### _find_mesh_instance

```gdscript
func _find_mesh_instance(node: Node) -> MeshInstance3D
```

Find MeshInstance3D in children recursively.

### _play_button_press_sound

```gdscript
func _play_button_press_sound() -> void
```

Play a random button press sound

### _play_button_release_sound

```gdscript
func _play_button_release_sound() -> void
```

Play a random button release sound

## Member Data Documentation

### timer

```gdscript
var timer: Node3D
```

Decorators: `@export`

Reference to the Timer object.

### sim_world

```gdscript
var sim_world: SimWorld
```

Decorators: `@export`

Reference to the SimWorld for pause/resume control.

### camera

```gdscript
var camera: Camera3D
```

Decorators: `@export`

Camera used for raycasting.

### button_mask

```gdscript
var button_mask: int
```

Decorators: `@export`

Collision layer for button detection.

### pause_button_bone

```gdscript
var pause_button_bone: String
```

Decorators: `@export`

Bone Name for the pause button.

### speed_1x_button_bone

```gdscript
var speed_1x_button_bone: String
```

Decorators: `@export`

Bone Name for the play button.

### speed_2x_button_bone

```gdscript
var speed_2x_button_bone: String
```

Decorators: `@export`

Bone Name for the speed button.

### press_depth

```gdscript
var press_depth: float
```

Decorators: `@export`

Animation parameter for how far the button depresses.

### press_duration

```gdscript
var press_duration: float
```

Decorators: `@export`

Animation parameter for duration of animation.

### collision_box_size

```gdscript
var collision_box_size: Vector3
```

Decorators: `@export`

Button Collision box size.

### collision_box_position

```gdscript
var collision_box_position: Vector3
```

Decorators: `@export`

Button Collision box position.

### debug_draw_collision

```gdscript
var debug_draw_collision: bool
```

Decorators: `@export`

Enable debug visualization of collision box.

### button_press_sounds

```gdscript
var button_press_sounds: Array[AudioStream]
```

Decorators: `@export`

Button press sound effects to play randomly when button is pressed

### button_release_sounds

```gdscript
var button_release_sounds: Array[AudioStream]
```

Decorators: `@export`

Button release sound effects to play randomly when button is released

### button_sound_pitch_variation

```gdscript
var button_sound_pitch_variation: float
```

Decorators: `@export`

Random pitch variation range (0.0 = no variation, 0.1 = ±10%, etc.)

### lcd_surface_index

```gdscript
var lcd_surface_index: int
```

Decorators: `@export`

Surface material override index for LCD.

### lcd_resolution

```gdscript
var lcd_resolution: Vector2i
```

Decorators: `@export`

Display resolution.

### lcd_bg_color

```gdscript
var lcd_bg_color: Color
```

Decorators: `@export`

Display background color.

### lcd_text_color

```gdscript
var lcd_text_color: Color
```

Decorators: `@export`

Display text color.

### lcd_font

```gdscript
var lcd_font: FontFile
```

Decorators: `@export`

Display font.

### lcd_font_size

```gdscript
var lcd_font_size: int
```

Decorators: `@export`

Display font size.

### lcd_letter_spacing

```gdscript
var lcd_letter_spacing: int
```

Decorators: `@export`

Letter spacing (kerning) - negative values tighten, positive values loosen.

### pause_icon

```gdscript
var pause_icon: Texture2D
```

Decorators: `@export`

Icon texture for pause state.

### play_icon

```gdscript
var play_icon: Texture2D
```

Decorators: `@export`

Icon texture for play/1x speed state.

### fastforward_icon

```gdscript
var fastforward_icon: Texture2D
```

Decorators: `@export`

Icon texture for fast-forward/2x speed state.

### icon_size

```gdscript
var icon_size: Vector2
```

Decorators: `@export`

Icon size on display.

### _skeleton

```gdscript
var _skeleton: Skeleton3D
```

### _pause_bone_idx

```gdscript
var _pause_bone_idx: int
```

### _speed_1x_bone_idx

```gdscript
var _speed_1x_bone_idx: int
```

### _speed_2x_bone_idx

```gdscript
var _speed_2x_bone_idx: int
```

### _animating_bones

```gdscript
var _animating_bones: Dictionary
```

### _debug_mesh

```gdscript
var _debug_mesh: MeshInstance3D
```

### _current_pressed_bone

```gdscript
var _current_pressed_bone: int
```

### _bone_rest_positions

```gdscript
var _bone_rest_positions: Dictionary
```

### _lcd_viewport

```gdscript
var _lcd_viewport: SubViewport
```

### _lcd_label

```gdscript
var _lcd_label: Label
```

### _lcd_icon

```gdscript
var _lcd_icon: TextureRect
```

### _sim_elapsed_time

```gdscript
var _sim_elapsed_time: float
```

### _button_sound_player

```gdscript
var _button_sound_player: AudioStreamPlayer3D
```

## Enumeration Type Documentation

### TimeState

```gdscript
enum TimeState
```

Time scale state.
