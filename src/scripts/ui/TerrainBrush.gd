@tool
@icon("res://icons/TerrainBrush.svg")
extends Resource
class_name TerrainBrush

## Defines how a terrain feature is drawn on the tactical map and how it
## influences simulation (movement, LOS, combat).
##
## Designers create .tres instances for roads, rivers, forests, urban, etc.
##
## @experimental  Values may evolve as balance solidifies.

# ---- Types ------------------------------------------------------------------
enum FeatureType { LINEAR, AREA, POINT }
enum DrawMode   { SOLID, DASHED, DOTTED, HATCHED, SYMBOL_TILED }
enum SymbolAlign { ALONG_TANGENT, SCREEN_UP }

enum MoveProfile { TRACKED, WHEELED, FOOT, RIVERINE }

# ---- Rendering --------------------------------------------------------------
@export var feature_type: FeatureType = FeatureType.LINEAR
@export var draw_mode: DrawMode = DrawMode.SOLID
@export var z_index: int = 0

@export_group("Stroke")
@export var stroke_color: Color = Color(0.15, 0.85, 0.3, 0.9)
@export_range(0.5, 12.0, 0.5) var stroke_width_px: float = 2.0
@export var dash_px: float = 8.0
@export var gap_px: float = 6.0

@export_group("Fill (Area Features)")
@export var fill_color: Color = Color(0.1, 0.6, 0.2, 0.25)
@export var hatch_spacing_px: float = 8.0
@export var hatch_angle_deg: float = 45.0

@export_group("Symbol (Tiled)")
@export var symbol: Texture2D
@export var symbol_spacing_px: float = 24.0
@export var symbol_scale: float = 1.0
@export var symbol_align: SymbolAlign = SymbolAlign.ALONG_TANGENT

# ---- Gameplay ---------------------------------------------------------------

@export_group("Movement cost (multiplier)")
@export var mv_tracked: float = 1.0
@export var mv_wheeled: float = 1.0
@export var mv_foot: float = 1.0
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

# ---- API --------------------------------------------------------------------
## Returns the movement multiplier for a given profile.
## [param profile] One of [code]MoveProfile[/code].
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

## Provides a light-weight draw recipe that your renderer can consume.
## The actual drawing is handled by the map layer, not the resource.
func get_draw_recipe() -> Dictionary:
	return {
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
