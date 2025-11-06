class_name SkyPreset
extends Resource

@export_category("Sky Settings")
@export_group("Sun Adjustments")
## Radius of sun sphere
@export_range(0, 0.001, 0.00001) var sun_radius: float = 0.0003
## Blur on suns edge
@export_range(1500, 10000, 50) var sun_edge_blur: float = 3600.0
## Intensity of sunlight
@export var sun_light_intensity: Curve
## Intensity of sun glow
@export_range(0, 1, 0.01) var sun_glow_intensity: float = 0.45

@export_group("Moon Adjustments")
## Radius of moon sphere
@export_range(0, 0.001, 0.00001) var moon_radius: float = 0.0003
## Blur on moons edge
@export_range(1500, 10000, 50) var moon_edge_blur: float = 10000.0
## Intensity of moonlight
@export var moon_light_intensity: Curve
## Intensity of moon glow
@export_range(0, 1, 0.01) var moon_glow_intensity: float = 0.8

@export_group("Horizon Adjustments")
## Size of horizon
@export_range(1.0, 7.0, 0.1) var horizon_size: float = 3.0
## Transparency of horizon
@export_range(0.0, 1.0, 0.01) var horizon_alpha: float = 1.0

@export_group("Clouds")
## Speed of clouds
@export_range(0.0, 0.003, 0.00001) var cloud_speed: float = 0.0003
## Direction of clouds
@export var cloud_direction: Vector2 = Vector2(1.0, 1.0)
## Density of clouds
@export_range(0.0, 8.0, 0.05) var cloud_density: float = 4.25
## Glow of clouds
@export_range(0.5, 0.99, 0.01) var cloud_glow: float = 0.92
## Light absorbtion of clouds
@export_range(0.0, 5.0, 0.001) var cloud_light_absorbtion: float = 5.0
## Brightness of clouds
@export_range(0.5, 1.0, 0.001) var cloud_brightness: float = 0.9
## UV Curvature of clouds
@export_range(0.5, 1.0, 0.001) var cloud_uv_curvature: float = 0.5
## Edge of clouds
@export_range(0.0, 1.0, 0.001) var cloud_edge: float = 0.0
## Cloud anistropy
@export_range(0.5, 1.0, 0.001) var anisotropy: float = 0.69

@export_group("Stars")
## Color of starts
@export var star_color: Color = Color(0.43, 0.55, 0.91)
## Star brightness
@export_range(0.0, 0.5, 0.01) var star_brightness: float = 0.2
## Star resolution
@export_range(-1.0, 3.0, 1.0) var star_resolution: float = 1.0
## Star twinkle speed
@export_range(0.0, 0.05, 0.001) var twinkle_speed: float = 0.025
## Star twinkle scale
@export_range(0.5, 5.0, 0.1) var twinkle_scale: float = 4.0
## Speed of stars
@export_range(0.0, 0.005, 0.0001) var star_speed: float = 0.002

@export_group("Color Curves")
@export var base_sky_color: GradientTexture1D
@export var base_cloud_color: GradientTexture1D
@export var overcast_sky_color: GradientTexture1D
@export var horizon_fog_color: GradientTexture1D
@export var sun_light_color: GradientTexture1D
@export var sun_disc_color: GradientTexture1D
@export var sun_glow: GradientTexture1D
@export var moon_light_color: GradientTexture1D
@export var moon_glow_color: GradientTexture1D
