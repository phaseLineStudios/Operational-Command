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

## Detailed Description

Update all weather parameters at once
`rain_mm_h` Rainfall intensity in mm/h
`fog_visibility_m` Fog visibility in meters
`wind_speed_m_s` Wind speed in m/s
`wind_direction_deg` Wind azimuth in degrees

## Public Member Functions

- [`func _update_time(dt: float) -> void`](EnvironmentController/functions/_update_time.md) — Check if simulating day/night cycle, determine rate of time, and increase time
- [`func _update_lights() -> void`](EnvironmentController/functions/_update_lights.md) — Update sun and moon based on current time of day
- [`func _update_rotation() -> void`](EnvironmentController/functions/_update_rotation.md) — Update rotation of sun and moon
- [`func _update_sky() -> void`](EnvironmentController/functions/_update_sky.md) — Update colors based on current time of day
- [`func _update_environment() -> void`](EnvironmentController/functions/_update_environment.md)
- [`func tick(dt: float) -> void`](EnvironmentController/functions/tick.md) — Tick time
- [`func _ready() -> void`](EnvironmentController/functions/_ready.md)
- [`func _process(dt: float) -> void`](EnvironmentController/functions/_process.md)
- [`func set_rain_intensity(intensity_mm_h: float) -> void`](EnvironmentController/functions/set_rain_intensity.md) — Set rain intensity and update particle effects
- [`func set_fog_visibility(visibility_m: float) -> void`](EnvironmentController/functions/set_fog_visibility.md) — Set fog visibility distance
- [`func set_wind(speed_m_s: float, direction_deg: float) -> void`](EnvironmentController/functions/set_wind.md) — Set wind parameters
- [`func _update_rain_particles() -> void`](EnvironmentController/functions/_update_rain_particles.md) — Internal: Update rain particle system based on intensity
- [`func _update_fog() -> void`](EnvironmentController/functions/_update_fog.md) — Internal: Update fog density based on visibility distance
- [`func _update_wind_effects() -> void`](EnvironmentController/functions/_update_wind_effects.md) — Internal: Update wind effects on particles and clouds
- [`func _update_weather_cloud_coverage() -> void`](EnvironmentController/functions/_update_weather_cloud_coverage.md) — Internal: Update cloud coverage based on weather conditions
- [`func get_rain_intensity() -> float`](EnvironmentController/functions/get_rain_intensity.md) — Get current rain intensity
- [`func get_fog_visibility() -> float`](EnvironmentController/functions/get_fog_visibility.md) — Get current fog visibility
- [`func get_wind_speed() -> float`](EnvironmentController/functions/get_wind_speed.md) — Get current wind speed
- [`func get_wind_direction() -> float`](EnvironmentController/functions/get_wind_direction.md) — Get current wind direction
- [`func get_weather() -> Dictionary`](EnvironmentController/functions/get_weather.md) — Get all current weather parameters

## Public Attributes

- `float time_of_day` — Current time (in seconds)
- `PackedScene environment_scene` — Environment scene
- `ScenarioData: scenario` — Scenario
- `Node3D sun_moon_parent` — Parent of the sun and moon nodes
- `MeshInstance3D sun_root`
- `MeshInstance3D moon_root`
- `DirectionalLight3D sun`
- `DirectionalLight3D moon`
- `Node3D env_anchor`
- `Node3D weather`
- `GPUParticles3D rain_node`
- `bool sun_shadow` — Enable sun shadows
- `bool moon_shadow` — Enable moon shadows
- `SkyPreset sky_preset` — Sky settings
- `float sky_rotation` — Sky rotation
- `float cloud_coverage` — Overcast (base value, rain will increase this)
- `bool animate_clouds` — Animate clouds
- `bool animate_star_map` — Animate stars
- `float rain_intensity` — Rainfall intensity in millimeters per hour
- `float fog_visibility` — Fog visibility distance in meters (lower = denser fog)
- `float wind_speed` — Wind speed in meters per second
- `float wind_direction` — Wind direction in degrees (0° = North, 90° = East, 180° = South, 270° = West)
- `Curve fog_visibility_curve` — Fog density curve: X-axis = visibility (0-10000m), Y-axis = fog density (0.0-0.30)
- `SceneEnvironment env_scene`
- `float sun_position`
- `float _set_cloud_coverage`
- `float _cloud_brightness_modifier`
- `float _light_power_modifier`
- `float _sky_brightness_modifier`
- `float _last_update_time`
- `float _cached_sun_position`

## Public Constants

- `const UPDATE_INTERVAL: float` — Update interval for _process() to avoid every-frame shader updates
- `const SUN_POSITION_THRESHOLD: float` — Cache previous sun position to avoid redundant shader updates

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
func _process(dt: float) -> void
```

### set_rain_intensity

```gdscript
func set_rain_intensity(intensity_mm_h: float) -> void
```

Set rain intensity and update particle effects
`intensity_mm_h` Rainfall in millimeters per hour (0.0 - 50.0)

### set_fog_visibility

```gdscript
func set_fog_visibility(visibility_m: float) -> void
```

Set fog visibility distance
`visibility_m` Visibility distance in meters (0.0 - 10000.0)
Lower values = denser fog

### set_wind

```gdscript
func set_wind(speed_m_s: float, direction_deg: float) -> void
```

Set wind parameters
`speed_m_s` Wind speed in meters per second (0.0 - 110.0)
`direction_deg` Wind azimuth direction in degrees (0.0 - 360.0)
0° = North, 90° = East, 180° = South, 270° = West

### _update_rain_particles

```gdscript
func _update_rain_particles() -> void
```

Internal: Update rain particle system based on intensity

### _update_fog

```gdscript
func _update_fog() -> void
```

Internal: Update fog density based on visibility distance

### _update_wind_effects

```gdscript
func _update_wind_effects() -> void
```

Internal: Update wind effects on particles and clouds

### _update_weather_cloud_coverage

```gdscript
func _update_weather_cloud_coverage() -> void
```

Internal: Update cloud coverage based on weather conditions

### get_rain_intensity

```gdscript
func get_rain_intensity() -> float
```

Get current rain intensity
[return] Current rainfall in mm/h

### get_fog_visibility

```gdscript
func get_fog_visibility() -> float
```

Get current fog visibility
[return] Current visibility distance in meters

### get_wind_speed

```gdscript
func get_wind_speed() -> float
```

Get current wind speed
[return] Current wind speed in m/s

### get_wind_direction

```gdscript
func get_wind_direction() -> float
```

Get current wind direction
[return] Current wind azimuth in degrees

### get_weather

```gdscript
func get_weather() -> Dictionary
```

Get all current weather parameters
[return] Dictionary with keys: rain_mm_h, fog_visibility_m, wind_speed_m_s, wind_direction_deg

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

### scenario

```gdscript
var scenario: ScenarioData:
```

Decorators: `@export`

Scenario

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

### weather

```gdscript
var weather: Node3D
```

### rain_node

```gdscript
var rain_node: GPUParticles3D
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

Overcast (base value, rain will increase this)

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

### rain_intensity

```gdscript
var rain_intensity: float
```

Decorators: `@export_range(0.0, 50.0, 0.5)`

Rainfall intensity in millimeters per hour

### fog_visibility

```gdscript
var fog_visibility: float
```

Decorators: `@export_range(0.0, 10000.0, 10.0)`

Fog visibility distance in meters (lower = denser fog)

### wind_speed

```gdscript
var wind_speed: float
```

Decorators: `@export_range(0.0, 110.0, 0.5)`

Wind speed in meters per second

### wind_direction

```gdscript
var wind_direction: float
```

Decorators: `@export_range(0.0, 360.0, 1.0)`

Wind direction in degrees (0° = North, 90° = East, 180° = South, 270° = West)

### fog_visibility_curve

```gdscript
var fog_visibility_curve: Curve
```

Decorators: `@export`

Fog density curve: X-axis = visibility (0-10000m), Y-axis = fog density (0.0-0.30)
If null, uses default piecewise curve based on meteorological severity table

### env_scene

```gdscript
var env_scene: SceneEnvironment
```

### sun_position

```gdscript
var sun_position: float
```

### _set_cloud_coverage

```gdscript
var _set_cloud_coverage: float
```

### _cloud_brightness_modifier

```gdscript
var _cloud_brightness_modifier: float
```

### _light_power_modifier

```gdscript
var _light_power_modifier: float
```

### _sky_brightness_modifier

```gdscript
var _sky_brightness_modifier: float
```

### _last_update_time

```gdscript
var _last_update_time: float
```

### _cached_sun_position

```gdscript
var _cached_sun_position: float
```

## Constant Documentation

### UPDATE_INTERVAL

```gdscript
const UPDATE_INTERVAL: float
```

Update interval for _process() to avoid every-frame shader updates

### SUN_POSITION_THRESHOLD

```gdscript
const SUN_POSITION_THRESHOLD: float
```

Cache previous sun position to avoid redundant shader updates
