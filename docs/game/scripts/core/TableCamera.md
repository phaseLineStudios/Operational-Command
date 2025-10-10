# TableCamera Class Reference

*File:* `scripts/core/Camera.gd`
*Class name:* `TableCamera`
*Inherits:* `Node`

## Synopsis

```gdscript
class_name TableCamera
extends Node
```

## Public Member Functions

- [`func _ready()`](TableCamera/functions/_ready.md)
- [`func _physics_process(delta: float) -> void`](TableCamera/functions/_physics_process.md)
- [`func _clamp_to_bounds() -> void`](TableCamera/functions/_clamp_to_bounds.md) — Clamp Camera position to bounds
- [`func _clamp_vec3_to_bounds(p: Vector3) -> Vector3`](TableCamera/functions/_clamp_vec3_to_bounds.md) — Clamp an arbitrary position to bounds
- [`func _update_target_tilt_from_z() -> void`](TableCamera/functions/_update_target_tilt_from_z.md) — Update camera tilt
- [`func _damp_vec3(a: Vector3, b: Vector3, k: float, dt: float) -> Vector3`](TableCamera/functions/_damp_vec3.md) — Exponential damping for vectors
- [`func _damp_scalar(a: float, b: float, k: float, dt: float) -> float`](TableCamera/functions/_damp_scalar.md) — Exponential damping for scalars

## Public Attributes

- `Vector2 move_speed` — Camera movement speed
- `float move_smooth` — Camera movement smoothing
- `float z_tilt_min_deg` — Camera minimum tilt angle in degrees
- `float z_tilt_max_deg` — Camera maximum tilt angle in degrees
- `float tilt_smooth` — Camera tilt smoothing
- `MeshInstance3D bounds`
- `Camera3D camera`

## Member Function Documentation

### _ready

```gdscript
func _ready()
```

### _physics_process

```gdscript
func _physics_process(delta: float) -> void
```

### _clamp_to_bounds

```gdscript
func _clamp_to_bounds() -> void
```

Clamp Camera position to bounds

### _clamp_vec3_to_bounds

```gdscript
func _clamp_vec3_to_bounds(p: Vector3) -> Vector3
```

Clamp an arbitrary position to bounds

### _update_target_tilt_from_z

```gdscript
func _update_target_tilt_from_z() -> void
```

Update camera tilt

### _damp_vec3

```gdscript
func _damp_vec3(a: Vector3, b: Vector3, k: float, dt: float) -> Vector3
```

Exponential damping for vectors

### _damp_scalar

```gdscript
func _damp_scalar(a: float, b: float, k: float, dt: float) -> float
```

Exponential damping for scalars

## Member Data Documentation

### move_speed

```gdscript
var move_speed: Vector2
```

Decorators: `@export`

Camera movement speed

### move_smooth

```gdscript
var move_smooth: float
```

Decorators: `@export`

Camera movement smoothing

### z_tilt_min_deg

```gdscript
var z_tilt_min_deg: float
```

Decorators: `@export`

Camera minimum tilt angle in degrees

### z_tilt_max_deg

```gdscript
var z_tilt_max_deg: float
```

Decorators: `@export`

Camera maximum tilt angle in degrees

### tilt_smooth

```gdscript
var tilt_smooth: float
```

Decorators: `@export`

Camera tilt smoothing

### bounds

```gdscript
var bounds: MeshInstance3D
```

### camera

```gdscript
var camera: Camera3D
```
