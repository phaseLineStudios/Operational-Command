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
	pass


## Optional helper to derive weather severity from a ScenarioData.
func weather_severity_from_scenario(scenario_weather: Variant) -> float:
	pass


## Optional helper to apply behaviour-based modifiers.
func behaviour_visibility_multiplier(behaviour: int) -> float:
	pass
