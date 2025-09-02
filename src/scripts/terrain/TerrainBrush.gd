@icon("res://icons/TerrainBrush.svg")
extends Resource
class_name TerrainBrush

## Defines how a terrain feature is drawn on the tactical map and how it
## influences simulation (movement, LOS, combat).
##
## Designers create .tres instances for roads, rivers, forests, urban, etc.
##
## @experimental  Values may evolve as balance solidifies.

## Type of feature geometry.
enum FeatureType { LINEAR, AREA, POINT }
## Rendering mode for the feature.
enum DrawMode   { SOLID, DASHED, DOTTED, HATCHED, SYMBOL_TILED }
## Orientation of tiled symbols.
enum SymbolAlign { ALONG_TANGENT, SCREEN_UP }
## Movement profile of a unit type.
enum MoveProfile { TRACKED, WHEELED, FOOT, RIVERINE }

## Legend Title
@export var legend_title: String = ""
## The geometry type of the feature (line, polygon, or point).
@export var feature_type: FeatureType = FeatureType.LINEAR
## Drawing style used for rendering the feature.
@export var draw_mode: DrawMode = DrawMode.SOLID
## Rendering order relative to other features.
@export var z_index: int = 0

@export_group("Outline")
## Outline color of the feature.
@export var stroke_color: Color = Color(0.15, 0.85, 0.3, 0.9)
## Outline width in pixels.
@export_range(0.5, 12.0, 0.5) var stroke_width_px: float = 2.0
## Dash length in pixels (when dashed mode is used).
@export var dash_px: float = 8.0
## Gap length between dashes (when dashed mode is used).
@export var gap_px: float = 6.0

@export_group("Fill (Area Features)")
## Fill color of polygons.
@export var fill_color: Color = Color(0.1, 0.6, 0.2, 0.25)
## Spacing of hatch lines in pixels.
@export var hatch_spacing_px: float = 8.0
## Angle of hatch lines in degrees.
@export var hatch_angle_deg: float = 45.0

@export_group("Symbol (Tiled)")
## Symbol texture for tiled rendering.
@export var symbol: Texture2D
## Spacing between repeated symbols in pixels.
@export var symbol_spacing_px: float = 24.0
## Scale factor for symbol rendering.
@export var symbol_scale: float = 1.0
## Alignment of symbols relative to geometry.
@export var symbol_align: SymbolAlign = SymbolAlign.ALONG_TANGENT

@export_group("Movement cost (multiplier)")
## Movement multiplier for tracked vehicles.
@export var mv_tracked: float = 1.0
## Movement multiplier for wheeled vehicles.
@export var mv_wheeled: float = 1.0
## Movement multiplier for foot infantry.
@export var mv_foot: float = 1.0
## Movement multiplier for riverine units.
@export var mv_riverine: float = 1.0

@export_group("LOS & Spotting")
## Linear attenuation per meter traversed “through” the feature (0..1).
@export_range(0.0, 1.0, 0.01) var los_attenuation_per_m: float = 0.0
## Additive penalty to initial detection (meters).
@export var spotting_penalty_m: float = 0.0

@export_group("Cover & Concealment")
## Percentage reduction to incoming attack power (0..1).
@export_range(0.0, 1.0, 0.05) var cover_reduction: float = 0.0
## Percentage reduction to chance of being spotted (0..1).
@export_range(0.0, 1.0, 0.05) var concealment: float = 0.0

@export_group("Special")
## (Roads) Preferred multiplier for routing heuristic (<1 = preferred).
@export var road_bias: float = 1.0
## (Bridges) Max mass in tons that can traverse; 0 = unlimited/not a bridge.
@export var bridge_capacity_tons: float = 0.0
## (Rivers) Width in meters (useful for crossing logic).
@export var river_width_m: float = 0.0

## Returns the movement multiplier for a given profile.
func movement_multiplier(profile: int) -> float:
	match profile:
		MoveProfile.TRACKED: return mv_tracked
		MoveProfile.WHEELED: return mv_wheeled
		MoveProfile.FOOT: return mv_foot
		MoveProfile.RIVERINE: return mv_riverine
		_: return 1.0

## Returns cumulative LOS attenuation for a ray marching [code]length_m[/code].
func los_attenuation_for_length(length_m: float) -> float:
	return clamp(los_attenuation_per_m * max(length_m, 0.0), 0.0, 1.0)

## Returns a simple defensive modifier bundle for Combat.gd.
func defensive_modifiers() -> Dictionary:
	return {
		"cover_reduction": cover_reduction,
		"concealment": concealment
	}

## Provide a light-weight draw recipe for the renderer.
func get_draw_recipe() -> Dictionary:
	return {
		"title": legend_title,
		"type": feature_type,
		"mode": draw_mode,
		"z_index": z_index,
		"stroke": {
			"color": stroke_color,
			"width_px": stroke_width_px,
			"dash_px": dash_px,
			"gap_px": gap_px
		},
		"fill": {
			"color": fill_color,
			"hatch_spacing_px": hatch_spacing_px,
			"hatch_angle_deg": hatch_angle_deg
		},
		"symbol": {
			"tex": symbol,
			"spacing_px": symbol_spacing_px,
			"scale": symbol_scale,
			"align": symbol_align
		}
	}
