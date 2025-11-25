class_name VisibilityProfile
extends Resource
## Configuration for local visibility scoring and loss thresholds.
## This is a stub; populate fields and logic when implementing EnvBehaviorSystem.

# Weather/night multipliers and thresholds should be added here.
# Example placeholders:
@export var base_visibility_threshold: float = 0.5
@export var fog_visibility_penalty: float = 0.2
@export var night_visibility_penalty: float = 0.3


## Compute a normalized visibility score given terrain/weather context.
## [param terrain_renderer] TerrainRender reference.
## [param pos_m] Position in meters.
## [param scenario_weather] Dictionary or ScenarioData weather fields.
## [param behaviour] Behaviour enum or int to bias risk.
## [return] Float visibility score (0..1).
func compute_visibility_score(
	terrain_renderer: Variant, pos_m: Vector2, scenario_weather: Variant, behaviour: int
) -> float:
	var score: float = 1.0

	# Terrain concealment
	if terrain_renderer and terrain_renderer.has_method("get_surface_at_terrain_position"):
		var surf: Dictionary = terrain_renderer.get_surface_at_terrain_position(pos_m)
		if typeof(surf) == TYPE_DICTIONARY and surf.has("brush"):
			var brush: Variant = surf.get("brush")
			if brush and brush.has_method("get"):
				var conceal: float = clamp(float(brush.get("concealment", 0.0)), 0.0, 1.0)
				score *= (1.0 - conceal)

	# Weather and night
	var weather_severity: float = weather_severity_from_scenario(scenario_weather)
	score *= (1.0 - weather_severity * fog_visibility_penalty)

	var hour: int = 12
	if typeof(scenario_weather) == TYPE_DICTIONARY:
		hour = int(scenario_weather.get("hour", hour))
	elif scenario_weather != null and "hour" in scenario_weather:
		hour = int(scenario_weather.hour)
	var night_mult: float = 1.0
	if hour < 6 or hour > 19:
		night_mult = 1.0 - night_visibility_penalty
	score *= night_mult

	# Behaviour
	score *= behaviour_visibility_multiplier(behaviour)

	return clamp(score, 0.0, 1.0)


## Optional helper to derive weather severity from a ScenarioData.
func weather_severity_from_scenario(scenario_weather: Variant) -> float:
	var fog_m: float = 8000.0
	var rain: float = 0.0
	if typeof(scenario_weather) == TYPE_DICTIONARY:
		fog_m = float(scenario_weather.get("fog_m", fog_m))
		rain = float(scenario_weather.get("rain", rain))
	elif scenario_weather != null:
		if "fog_m" in scenario_weather:
			fog_m = float(scenario_weather.fog_m)
		if "rain" in scenario_weather:
			rain = float(scenario_weather.rain)
	var fog_sev: float = clamp(1.0 - fog_m / 8000.0, 0.0, 1.0)
	var rain_sev: float = clamp(rain / 50.0, 0.0, 1.0)
	return max(fog_sev, rain_sev)


## Optional helper to apply behaviour-based modifiers.
func behaviour_visibility_multiplier(behaviour: int) -> float:
	match behaviour:
		0:  # CARELESS
			return 1.1
		1:  # SAFE
			return 1.0
		2:  # AWARE
			return 0.9
		3:  # COMBAT
			return 0.85
		4:  # STEALTH
			return 0.7
		_:
			return 1.0
