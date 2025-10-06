# TerrainCamera Class Reference

*File:* `scripts/editors/TerrainCamera.gd`
*Class name:* `TerrainCamera`
*Inherits:* `Camera2D`

## Synopsis

```gdscript
class_name TerrainCamera
extends Camera2D
```

## Public Member Functions

- [`func _ready() -> void`](TerrainCamera/functions/_ready.md)
- [`func _input(event: InputEvent) -> void`](TerrainCamera/functions/_input.md)
- [`func _process(_dt: float) -> void`](TerrainCamera/functions/_process.md)
- [`func _zoom_at_mouse(zoom_scale: float) -> void`](TerrainCamera/functions/_zoom_at_mouse.md)

## Public Attributes

- `MouseButton pan_button`
- `float pan_speed`
- `float zoom_step`
- `float min_zoom`
- `float max_zoom`
- `bool invert_pan`
- `Vector2 _pan_cam_start`
- `Vector2 _pan_mouse_world_start`
- `Vector2 _delta_world`

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### _input

```gdscript
func _input(event: InputEvent) -> void
```

### _process

```gdscript
func _process(_dt: float) -> void
```

### _zoom_at_mouse

```gdscript
func _zoom_at_mouse(zoom_scale: float) -> void
```

## Member Data Documentation

### pan_button

```gdscript
var pan_button: MouseButton
```

### pan_speed

```gdscript
var pan_speed: float
```

### zoom_step

```gdscript
var zoom_step: float
```

### min_zoom

```gdscript
var min_zoom: float
```

### max_zoom

```gdscript
var max_zoom: float
```

### invert_pan

```gdscript
var invert_pan: bool
```

### _pan_cam_start

```gdscript
var _pan_cam_start: Vector2
```

### _pan_mouse_world_start

```gdscript
var _pan_mouse_world_start: Vector2
```

### _delta_world

```gdscript
var _delta_world: Vector2
```
