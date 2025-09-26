extends RefCounted
class_name TerrainEffects
## Compute terrain/weather multipliers for combat/spotting.
## @experimental

## Returns accuracy/damage/spotting multipliers and LOS state.
## env:
## - "renderer": TerrainRender            # preferred source for surfaces
## - "terrain": TerrainData               # fallback for heights/brush
## - "scenario": ScenarioData             # derives weather if severity not set
## - "config": TerrainEffectsConfig
static func compute_terrain_factors(attacker: ScenarioUnit, defender: ScenarioUnit, env: Dictionary) -> Dictionary:
	var cfg: TerrainEffectsConfig = env.get("config", TerrainEffectsConfig.new())
	var renderer: Variant = env.get("renderer", null)
	var terrain: Variant = env.get("terrain", null)
	var scenario: Variant = env.get("scenario", null)
	if terrain == null and renderer != null and "data" in renderer:
		terrain = renderer.data

	var weather_severity: float = 0.0
	if scenario != null:
		weather_severity = weather_severity_from_scenario(env.scenario)

	var pos_a: Vector2 = _extract_pos(attacker, Vector2.ZERO)
	var pos_d: Vector2 = _extract_pos(defender, Vector2.ZERO)
	var range_m := pos_a.distance_to(pos_d)

	var acc := 1.0
	var dmg := 1.0
	var spot := 1.0

	var los := _compute_los_and_atten(pos_a, pos_d, renderer, terrain, cfg)
	if los.blocked:
		return { "accuracy_mul": 0.0, "damage_mul": 0.0, "spotting_mul": 0.0, "blocked": true, "range_m": range_m }

	var dh: float = clamp(_get_h(terrain, pos_a) - _get_h(terrain, pos_d), -cfg.elev_cap_m, cfg.elev_cap_m)
	acc *= 1.0 + cfg.k_elev_acc_per_m * dh

	var br := _brush_fields(renderer, terrain, pos_d)
	var cover: float = clamp(br.cover_reduction, 0.0, 1.0)
	var conceal: float = clamp(br.concealment, 0.0, 1.0)
	dmg *= 1.0 - cover * cfg.cover_damage_scale

	var conceal_scale: float = clamp(range_m / max(cfg.conceal_full_effect_range_m, 1.0), 0.0, 1.0)
	var conceal_factor := 1.0 - conceal * conceal_scale
	acc *= conceal_factor
	spot *= conceal_factor

	var atten_factor := exp(-max(los.atten_integral, 0.0))
	acc *= atten_factor
	spot *= atten_factor

	acc *= (1.0 - weather_severity * cfg.weather_acc_penalty_at_severity1)

	var is_moving := bool(env.attacker_moving) if env.has("attacker_moving") else _is_moving(attacker)
	if is_moving: acc *= (1.0 - cfg.moving_fire_penalty)
	var is_dug_in := bool(env.defender_dug_in) if env.has("defender_dug_in") else _is_dug_in(defender)
	if is_dug_in: dmg *= (1.0 - cfg.dug_in_cover_bonus)

	acc = max(acc, cfg.min_accuracy)
	dmg = max(dmg, cfg.min_damage)
	spot = max(spot, 0.05)

	if cfg.debug:
		print("[TerrainEffects] range=%.1f acc=%.3f dmg=%.3f spot=%.3f dh=%.1f atten=%.3f blocked=%s" % \
			[range_m, acc, dmg, spot, dh, float(los.atten_integral), str(false)])

	return { "accuracy_mul": acc, "damage_mul": dmg, "spotting_mul": spot, "blocked": false, "range_m": range_m }

## Derive 0..1 weather severity from ScenarioData (fog/rain)
static func weather_severity_from_scenario(s: ScenarioData) -> float:
	if s == null: return 0.0
	var fog: float = clamp(1.0 - float(s.fog_m) / 8000.0, 0.0, 1.0)
	var rain: float = clamp(float(s.rain) / 50.0, 0.0, 1.0)
	return clamp(max(fog, rain), 0.0, 1.0)

## LOS ray test + integral attenuation using TerrainRender surfaces when available
static func _compute_los_and_atten(a: Vector2, d: Vector2, renderer: TerrainRender, terrain: TerrainData, cfg: TerrainEffectsConfig) -> Dictionary:
	if a == d:
		return { "blocked": false, "atten_integral": 0.0 }

	var terr := terrain
	if terr == null and renderer != null and "data" in renderer:
		terr = renderer.data

	var ha := _get_h(terr, a) + cfg.los_attacker_eye_h_m
	var hd := _get_h(terr, d) + cfg.los_target_h_m
	var dist := a.distance_to(d)
	var steps := int(max(1.0, ceil(dist / max(cfg.los_raycast_step_m, 1.0))))
	var dir := (d - a) / float(steps)

	var atten := 0.0
	var blocked := false
	for i in range(1, steps):
		var p := a + dir * float(i)
		var t := float(i) / float(steps)
		var h_line: float = lerp(ha, hd, t)
		var h_terrain := _get_h(terr, p)
		if h_terrain > h_line:
			blocked = true
			break
		var br := _brush_fields(renderer, terr, p)
		var per_m: float = max(br.los_attenuation_per_m, 0.0)
		atten += per_m * min(cfg.los_raycast_step_m, dist)
	return { "blocked": blocked, "atten_integral": atten }

## Brush field adapter for either TerrainRender or TerrainData
static func _brush_fields(renderer: TerrainRender, _terrain: TerrainData, p: Vector2) -> Dictionary:
	if renderer != null and renderer.has_method("get_surface_at_terrain_position"):
		var s := renderer.get_surface_at_terrain_position(p)
		if typeof(s) == TYPE_DICTIONARY and s.has("brush"):
			var b: TerrainBrush = s.get("brush")
			if b != null:
				return {
					"cover_reduction": _try_field(b, "cover_reduction"),
					"concealment": _try_field(b, "concealment"),
					"los_attenuation_per_m": _try_field(b, "los_attenuation_per_m")
				}
	
	push_warning("Failed to get brush at ", p)
	return { "cover_reduction": 0.0, "concealment": 0.0, "los_attenuation_per_m": 0.0 }

static func _try_field(src: TerrainBrush, name: String, def: float = 0.0) -> float:
	if src == null: return def
	return float(src.get(name))

static func _get_h(terrain: TerrainData, p: Vector2) -> float:
	if terrain == null: return 0.0
	var px := terrain.world_to_elev_px(p)
	return float(terrain.get_elev_px(px)) + float(terrain.base_elevation_m)

static func _extract_pos(x: ScenarioUnit, fallback: Vector2) -> Vector2:
	if x == null: return fallback
	if "position_m" in x: return x.position_m
	if "world_pos" in x: return x.world_pos
	if x.has_method("get_world_pos"): return x.get_world_pos()
	return fallback

static func _is_moving(x: ScenarioUnit) -> bool:
	if x == null: return false
	if "moving" in x: return bool(x.moving)
	if "is_moving" in x: return bool(x.is_moving)
	if x.has_method("is_moving"): return bool(x.is_moving())
	if x.has_method("move_state"):
		var st := x.move_state()
		if typeof(st) == TYPE_INT: return st == 2
	if "_move_state" in x and typeof(x._move_state) == TYPE_INT:
		return int(x._move_state) == 2
	return false

## Currently has no effect. reserved for the future
## @experimental
static func _is_dug_in(x: ScenarioUnit) -> bool:
	if x == null: return false
	if "dug_in" in x: return bool(x.dug_in)
	if x.has_method("is_dug_in"): return bool(x.is_dug_in())
	return false
