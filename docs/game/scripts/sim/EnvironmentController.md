# EnvironmentController Class Reference

*File:* `scripts/sim/EnvironmentController.gd`
*Class name:* `EnvironmentController`
*Inherits:* `WorldEnvironment`

## Synopsis

```gdscript
class_name EnvironmentController
extends WorldEnvironment
```

## Brief

Controlls environmental factors

## Public Member Functions

- [`func _update_time(dt: float) -> void`](EnvironmentController/functions/_update_time.md) — Check if simulating day/night cycle, determine rate of time, and increase time
- [`func _update_lights() -> void`](EnvironmentController/functions/_update_lights.md) — Update sun and moon based on current time of day
- [`func _update_rotation() -> void`](EnvironmentController/functions/_update_rotation.md) — Update rotation of sun and moon
- [`func _update_sky() -> void`](EnvironmentController/functions/_update_sky.md) — Update colors based on current time of day
- [`func _update_environment() -> void`](EnvironmentController/functions/_update_environment.md)
- [`func tick(dt: float) -> void`](EnvironmentController/functions/tick.md) — Tick time
- [`func _ready() -> void`](EnvironmentController/functions/_ready.md)
- [`func _process(_dt: float) -> void`](EnvironmentController/functions/_process.md)

## Public Attributes

- `float time_of_day` — Current time (in seconds)
- `PackedScene environment_scene` — Environment scene
- `Node3D sun_moon_parent` — Parent of the sun and moon nodes
- `MeshInstance3D sun_root`
- `MeshInstance3D moon_root`
- `DirectionalLight3D sun`
- `DirectionalLight3D moon`
- `Node3D env_anchor`
- `bool sun_shadow` — Enable sun shadows
- `bool moon_shadow` — Enable moon shadows
- `SkyPreset sky_preset` — Sky settings
- `float sky_rotation` — Sky rotation
- `float cloud_coverage` — Overcast
- `bool animate_clouds` — Animate clouds
- `bool animate_star_map` — Animate stars
- `float sun_position`
- `float moon_position`
- `float sun_pos_alpha`
- `WorldEnvironment sky`

## Member Function Documentation

### _update_time

```gdscript
func _update_time(dt: float) -> void
```

Check if simulating day/night cycle, determine rate of time, and increase time

### _update_lights

```gdscript
func _update_lights() -> void
```

Update sun and moon based on current time of day

### _update_rotation

```gdscript
func _update_rotation() -> void
```

Update rotation of sun and moon

### _update_sky

```gdscript
func _update_sky() -> void
```

Update colors based on current time of day

### _update_environment

```gdscript
func _update_environment() -> void
```

### tick

```gdscript
func tick(dt: float) -> void
```

Tick time
`dt` Delta time since last tick

### _ready

```gdscript
func _ready() -> void
```

### _process

```gdscript
func _process(_dt: float) -> void
```

## Member Data Documentation

### time_of_day

```gdscript
var time_of_day: float
```

Decorators: `@export_range(0.0, 86400.0, 1.0)`

Current time (in seconds)

### environment_scene

```gdscript
var environment_scene: PackedScene
```

Decorators: `@export`

Environment scene

### sun_moon_parent

```gdscript
var sun_moon_parent: Node3D
```

Decorators: `@export`

Parent of the sun and moon nodes

### sun_root

```gdscript
var sun_root: MeshInstance3D
```

### moon_root

```gdscript
var moon_root: MeshInstance3D
```

### sun

```gdscript
var sun: DirectionalLight3D
```

### moon

```gdscript
var moon: DirectionalLight3D
```

### env_anchor

```gdscript
var env_anchor: Node3D
```

### sun_shadow

```gdscript
var sun_shadow: bool
```

Decorators: `@export`

Enable sun shadows

### moon_shadow

```gdscript
var moon_shadow: bool
```

Decorators: `@export`

Enable moon shadows

### sky_preset

```gdscript
var sky_preset: SkyPreset
```

Decorators: `@export`

Sky settings

### sky_rotation

```gdscript
var sky_rotation: float
```

Decorators: `@export_range(0, 36.0, 0.1)`

Sky rotation

### cloud_coverage

```gdscript
var cloud_coverage: float
```

Decorators: `@export_range(0, 1, 0.001)`

Overcast

### animate_clouds

```gdscript
var animate_clouds: bool
```

Decorators: `@export`

Animate clouds

### animate_star_map

```gdscript
var animate_star_map: bool
```

Decorators: `@export`

Animate stars

### sun_position

```gdscript
var sun_position: float
```

### moon_position

```gdscript
var moon_position: float
```

### sun_pos_alpha

```gdscript
var sun_pos_alpha: float
```

### sky

```gdscript
var sky: WorldEnvironment
```
