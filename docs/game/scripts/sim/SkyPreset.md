# SkyPreset Class Reference

*File:* `scripts/sim/SkyPreset.gd`
*Class name:* `SkyPreset`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name SkyPreset
extends Resource
```

## Public Attributes

- `float sun_radius` — Radius of sun sphere
- `float sun_edge_blur` — Blur on suns edge
- `Curve sun_light_intensity` — Intensity of sunlight
- `float sun_glow_intensity` — Intensity of sun glow
- `float moon_radius` — Radius of moon sphere
- `float moon_edge_blur` — Blur on moons edge
- `Curve moon_light_intensity` — Intensity of moonlight
- `float moon_glow_intensity` — Intensity of moon glow
- `float horizon_size` — Size of horizon
- `float horizon_alpha` — Transparency of horizon
- `float cloud_speed` — Speed of clouds
- `Vector2 cloud_direction` — Direction of clouds
- `float cloud_density` — Density of clouds
- `float cloud_glow` — Glow of clouds
- `float cloud_light_absorbtion` — Light absorbtion of clouds
- `float cloud_brightness` — Brightness of clouds
- `float cloud_uv_curvature` — UV Curvature of clouds
- `float cloud_edge` — Edge of clouds
- `float anisotropy` — Cloud anistropy
- `Color star_color` — Color of starts
- `float star_brightness` — Star brightness
- `float star_resolution` — Star resolution
- `float twinkle_speed` — Star twinkle speed
- `float twinkle_scale` — Star twinkle scale
- `float star_speed` — Speed of stars
- `GradientTexture1D base_sky_color`
- `GradientTexture1D base_cloud_color`
- `GradientTexture1D overcast_sky_color`
- `GradientTexture1D horizon_fog_color`
- `GradientTexture1D sun_light_color`
- `GradientTexture1D sun_disc_color`
- `GradientTexture1D sun_glow`
- `GradientTexture1D moon_light_color`
- `GradientTexture1D moon_glow_color`

## Member Data Documentation

### sun_radius

```gdscript
var sun_radius: float
```

Decorators: `@export_range(0, 0.001, 0.00001)`

Radius of sun sphere

### sun_edge_blur

```gdscript
var sun_edge_blur: float
```

Decorators: `@export_range(1500, 10000, 50)`

Blur on suns edge

### sun_light_intensity

```gdscript
var sun_light_intensity: Curve
```

Decorators: `@export`

Intensity of sunlight

### sun_glow_intensity

```gdscript
var sun_glow_intensity: float
```

Decorators: `@export_range(0, 1, 0.01)`

Intensity of sun glow

### moon_radius

```gdscript
var moon_radius: float
```

Decorators: `@export_range(0, 0.001, 0.00001)`

Radius of moon sphere

### moon_edge_blur

```gdscript
var moon_edge_blur: float
```

Decorators: `@export_range(1500, 10000, 50)`

Blur on moons edge

### moon_light_intensity

```gdscript
var moon_light_intensity: Curve
```

Decorators: `@export`

Intensity of moonlight

### moon_glow_intensity

```gdscript
var moon_glow_intensity: float
```

Decorators: `@export_range(0, 1, 0.01)`

Intensity of moon glow

### horizon_size

```gdscript
var horizon_size: float
```

Decorators: `@export_range(1.0, 7.0, 0.1)`

Size of horizon

### horizon_alpha

```gdscript
var horizon_alpha: float
```

Decorators: `@export_range(0.0, 1.0, 0.01)`

Transparency of horizon

### cloud_speed

```gdscript
var cloud_speed: float
```

Decorators: `@export_range(0.0, 0.003, 0.00001)`

Speed of clouds

### cloud_direction

```gdscript
var cloud_direction: Vector2
```

Decorators: `@export`

Direction of clouds

### cloud_density

```gdscript
var cloud_density: float
```

Decorators: `@export_range(0.0, 8.0, 0.05)`

Density of clouds

### cloud_glow

```gdscript
var cloud_glow: float
```

Decorators: `@export_range(0.5, 0.99, 0.01)`

Glow of clouds

### cloud_light_absorbtion

```gdscript
var cloud_light_absorbtion: float
```

Decorators: `@export_range(0.0, 5.0, 0.001)`

Light absorbtion of clouds

### cloud_brightness

```gdscript
var cloud_brightness: float
```

Decorators: `@export_range(0.5, 1.0, 0.001)`

Brightness of clouds

### cloud_uv_curvature

```gdscript
var cloud_uv_curvature: float
```

Decorators: `@export_range(0.5, 1.0, 0.001)`

UV Curvature of clouds

### cloud_edge

```gdscript
var cloud_edge: float
```

Decorators: `@export_range(0.0, 1.0, 0.001)`

Edge of clouds

### anisotropy

```gdscript
var anisotropy: float
```

Decorators: `@export_range(0.5, 1.0, 0.001)`

Cloud anistropy

### star_color

```gdscript
var star_color: Color
```

Decorators: `@export`

Color of starts

### star_brightness

```gdscript
var star_brightness: float
```

Decorators: `@export_range(0.0, 0.5, 0.01)`

Star brightness

### star_resolution

```gdscript
var star_resolution: float
```

Decorators: `@export_range(-1.0, 3.0, 1.0)`

Star resolution

### twinkle_speed

```gdscript
var twinkle_speed: float
```

Decorators: `@export_range(0.0, 0.05, 0.001)`

Star twinkle speed

### twinkle_scale

```gdscript
var twinkle_scale: float
```

Decorators: `@export_range(0.5, 5.0, 0.1)`

Star twinkle scale

### star_speed

```gdscript
var star_speed: float
```

Decorators: `@export_range(0.0, 0.005, 0.0001)`

Speed of stars

### base_sky_color

```gdscript
var base_sky_color: GradientTexture1D
```

### base_cloud_color

```gdscript
var base_cloud_color: GradientTexture1D
```

### overcast_sky_color

```gdscript
var overcast_sky_color: GradientTexture1D
```

### horizon_fog_color

```gdscript
var horizon_fog_color: GradientTexture1D
```

### sun_light_color

```gdscript
var sun_light_color: GradientTexture1D
```

### sun_disc_color

```gdscript
var sun_disc_color: GradientTexture1D
```

### sun_glow

```gdscript
var sun_glow: GradientTexture1D
```

### moon_light_color

```gdscript
var moon_light_color: GradientTexture1D
```

### moon_glow_color

```gdscript
var moon_glow_color: GradientTexture1D
```
