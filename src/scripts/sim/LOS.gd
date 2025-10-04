extends Node
## LOS & spotting helpers
## @experimental

## Simple LOS with attenuation
func trace_los(a: Vector2, d: Vector2, renderer: Variant, terrain: Variant, cfg: TerrainEffectsConfig) -> Dictionary:
	var res := TerrainEffects._compute_los_and_atten(a, d, renderer, terrain, cfg)
	return { "blocked": res.blocked, "atten_integral": float(res.atten_integral), "range_m": a.distance_to(d) }

## Spotting multiplier from conceal + weather
func compute_spotting_mul(renderer: TerrainRender, terrain: TerrainData, pos_d: Vector2, range_m: float, weather_severity: float, cfg: TerrainEffectsConfig) -> float:
	var br := TerrainEffects._brush_fields(renderer, terrain, pos_d)
	var conceal: float = clamp(float(br.concealment), 0.0, 1.0)
	var conceal_scale: float = clamp(range_m / max(cfg.conceal_full_effect_range_m, 1.0), 0.0, 1.0)
	var mul := 1.0 - conceal * conceal_scale
	mul *= (1.0 - clamp(weather_severity, 0.0, 1.0) * cfg.weather_acc_penalty_at_severity1)
	return max(mul, 0.05)
