class_name TerrainEffects
extends RefCounted
## Compute terrain/weather multipliers for combat/spotting
## @experimental


## Returns accuracy/damage/spotting multipliers and LOS state
static func compute_terrain_factors(
	attacker: ScenarioUnit, defender: ScenarioUnit, env: Dictionary
) -> Dictionary:
	var cfg: TerrainEffectsConfig = env.get("config", TerrainEffectsConfig.new())
	var renderer: TerrainRender = env.get("renderer")
	var terrain: TerrainData = env.get("terrain")
	var scenario: ScenarioData = env.get("scenario")
	if terrain == null and renderer != null and "data" in renderer:
		terrain = renderer.data

	var weather_severity := 0.0
	if scenario != null:
		weather_severity = weather_severity_from_scenario(scenario)

	var pos_a := _extract_pos(attacker, Vector2.ZERO)
	var pos_d := _extract_pos(defender, Vector2.ZERO)
	var range_m := pos_a.distance_to(pos_d)

	var acc := 1.0
	var dmg := 1.0
	var spot := 1.0

	var los := _compute_los_and_atten(pos_a, pos_d, renderer, terrain, cfg)
	if los.blocked:
		var ret0 := {
			"accuracy_mul": 0.0,
			"damage_mul": 0.0,
			"spotting_mul": 0.0,
			"blocked": true,
			"block_reason": "terrain_occlusion",
			"range_m": range_m
		}
		if env.get("debug", false) or cfg.debug:
			ret0["debug"] = {
				"atten_integral": float(los.atten_integral), "weather_severity": weather_severity
			}
		return ret0

	var dh: float = clamp(
		_get_h(terrain, pos_a) - _get_h(terrain, pos_d), -cfg.elev_cap_m, cfg.elev_cap_m
	)
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

	var is_moving := (
		(env.has("attacker_moving") and bool(env.get("attacker_moving"))) or _is_moving(attacker)
	)
	if is_moving:
		acc *= (1.0 - cfg.moving_fire_penalty)

	var is_dug_in := (
		(env.has("defender_dug_in") and bool(env.get("defender_dug_in"))) or _is_dug_in(defender)
	)
	if is_dug_in:
		dmg *= (1.0 - cfg.dug_in_cover_bonus)

	acc = max(acc, 0.0)
	var blocked := acc < cfg.min_accuracy
	var block_reason := "below_min_accuracy" if blocked else ""

	var out_acc := acc
	var out_dmg: float = max(dmg, cfg.min_damage)
	var out_spot: float = max(spot, 0.05)

	var dbg := {
		"dh_m": dh,
		"cover": cover,
		"conceal": conceal,
		"atten_integral": float(los.atten_integral),
		"weather_severity": weather_severity,
		"is_moving": is_moving,
		"is_dug_in": is_dug_in
	}

	var ret := {
		"accuracy_mul": out_acc,
		"damage_mul": out_dmg,
		"spotting_mul": out_spot,
		"blocked": blocked,
		"block_reason": block_reason,
		"range_m": range_m
	}
	if env.get("debug", false) or cfg.debug:
		ret["debug"] = dbg
	return ret


## Derive 0..1 weather severity from ScenarioData (fog/rain).
static func weather_severity_from_scenario(s: ScenarioData) -> float:
	if s == null:
		return 0.0
	var fog: float = clamp(1.0 - float(s.fog_m) / 8000.0, 0.0, 1.0)
	var rain: float = clamp(float(s.rain) / 50.0, 0.0, 1.0)
	return clamp(max(fog, rain), 0.0, 1.0)


## LOS test + integral attenuation via TerrainRender surfaces if available.
static func _compute_los_and_atten(
	a: Vector2,
	d: Vector2,
	renderer: TerrainRender,
	terrain: TerrainData,
	cfg: TerrainEffectsConfig,
	los_max_range_m: float = 0.0,
	max_samples: int = 256
) -> Dictionary:
	if a == d:
		return {"blocked": false, "atten_integral": 0.0}

	var terr := terrain
	if terr == null and renderer != null and "data" in renderer:
		terr = renderer.data

	var max_r: float = 0.0
	if cfg != null:
		max_r = float(los_max_range_m)
	if max_r > 0.0 and a.distance_squared_to(d) > max_r * max_r:
		return {"blocked": false, "atten_integral": 0.0}

	var ha := _get_h(terr, a) + cfg.los_attacker_eye_h_m
	var hd := _get_h(terr, d) + cfg.los_target_h_m
	var delta := d - a
	var dist := delta.length()
	var step_m: float = max(cfg.los_raycast_step_m, 1.0)

	var steps := int(ceil(dist / step_m))
	if max_samples > 0:
		steps = min(steps, max_samples)
	steps = max(1, steps)

	var inv_steps := 1.0 / float(steps)
	var step_vec := delta * inv_steps
	var step_len := dist * inv_steps
	var dh := hd - ha

	var atten := 0.0
	var blocked := false

	var last_per_m := -1.0
	var last_surface_id := -1
	var forest_samples := 0
	var total_samples := 0

	for i in range(1, steps):
		var t := float(i) * inv_steps
		var p := a + step_vec * float(i)

		var h_line := ha + dh * t
		var h_terrain := _get_h(terr, p)
		if h_terrain > h_line:
			blocked = true
			break

		var per_m := 0.0
		if renderer != null:
			var s := renderer.get_surface_at_terrain_position(p)
			if typeof(s) == TYPE_DICTIONARY and s.has("brush"):
				var sid := int(s.get("_id", -1))
				if sid == last_surface_id and last_per_m >= 0.0:
					per_m = last_per_m
				else:
					var b: TerrainBrush = s.get("brush")
					if b != null:
						per_m = _try_field(b, "los_attenuation_per_m")
						last_per_m = per_m
						last_surface_id = sid
		if per_m > 0.0:
			atten += per_m * step_len
			forest_samples += 1
		total_samples += 1

	# Debug: log long-range LOS traces to understand forest coverage
	if cfg and cfg.debug and dist > 800.0 and total_samples > 0:
		var forest_pct := float(forest_samples) / float(total_samples) * 100.0
		LogService.info(
			"LOS trace: dist=%.0fm, samples=%d, forest_hits=%d (%.1f%%), atten=%.2f"
			% [dist, total_samples, forest_samples, forest_pct, atten],
			"TerrainEffects"
		)

	return {"blocked": blocked, "atten_integral": atten}


## Brush field adapter for either TerrainRender or TerrainData (area features only).
static func _brush_fields(renderer: TerrainRender, _terrain: TerrainData, p: Vector2) -> Dictionary:
	if renderer != null:
		var s := renderer.get_surface_at_terrain_position(p)
		if typeof(s) == TYPE_DICTIONARY and s.has("brush"):
			var b: TerrainBrush = s.get("brush")
			if b != null:
				return {
					"cover_reduction": _try_field(b, "cover_reduction"),
					"concealment": _try_field(b, "concealment"),
					"los_attenuation_per_m": _try_field(b, "los_attenuation_per_m")
				}
	return {"cover_reduction": 0.0, "concealment": 0.0, "los_attenuation_per_m": 0.0}


static func _try_field(src: TerrainBrush, name: String, def: float = 0.0) -> float:
	if src == null:
		return def
	return float(src.get(name))


static func _get_h(terrain: TerrainData, p: Vector2) -> float:
	if terrain == null:
		return 0.0
	var px := terrain.world_to_elev_px(p)
	return float(terrain.get_elev_px(px)) + float(terrain.base_elevation_m)


static func _extract_pos(x: ScenarioUnit, fallback: Vector2) -> Vector2:
	if x == null:
		return fallback
	if "position_m" in x:
		return x.position_m
	if "world_pos" in x:
		return x.world_pos
	if x.has_method("get_world_pos"):
		return x.get_world_pos()
	return fallback


static func _is_moving(x: ScenarioUnit) -> bool:
	if x == null:
		return false
	if "moving" in x:
		return bool(x.moving)
	if "is_moving" in x:
		return bool(x.is_moving)
	if x.has_method("is_moving"):
		return bool(x.is_moving())
	if x.has_method("move_state"):
		var st := x.move_state()
		if typeof(st) == TYPE_INT:
			return st == 2
	if "_move_state" in x and typeof(x._move_state) == TYPE_INT:
		return int(x._move_state) == 2
	return false


## Reserved for future posture logic.
## @experimental
static func _is_dug_in(_x: ScenarioUnit) -> bool:
	return false
