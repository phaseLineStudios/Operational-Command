# SimDebugOverlay::_draw Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 215–331)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _draw() -> void
```

## Description

Draw icons, paths, destinations, labels, and bars for all units.

## Source

```gdscript
func _draw() -> void:
	if not debug_enabled:
		return

	if terrain_renderer == null or terrain_renderer.data == null:
		return

	if show_combat_lines and _sim:
		var pairs: Array = []
		if _sim.has_method("get_current_contacts"):
			pairs = _sim.get_current_contacts()
		for p in pairs:
			var aid := str(p.get("attacker", ""))
			var did := str(p.get("defender", ""))
			var a_su: ScenarioUnit = _unit_by_id.get(aid)
			var d_su: ScenarioUnit = _unit_by_id.get(did)
			if a_su == null or d_su == null:
				continue
			if a_su.is_dead() or d_su.is_dead():
				continue
			var a_px := terrain_renderer.terrain_to_map(a_su.position_m)
			var d_px := terrain_renderer.terrain_to_map(d_su.position_m)
			draw_line(a_px, d_px, combat_line_color, combat_line_width_px)

	var units: Array[ScenarioUnit] = []
	units.append_array(Game.current_scenario.units)
	units.append_array(Game.current_scenario.playable_units)

	for unit in units:
		var pos_m: Vector2 = terrain_renderer.terrain_to_map(unit.position_m)
		var friend := unit.affiliation == ScenarioUnit.Affiliation.FRIEND
		var col := friend_color if friend else enemy_color

		if show_paths:
			var path_m: PackedVector2Array = unit.current_path()
			if path_m.size() >= 2:
				var poly: PackedVector2Array = []
				for i in path_m:
					poly.append(terrain_renderer.terrain_to_map(i))
				draw_polyline(poly, col, path_width_px, true)

		if show_destinations:
			var dst_m := unit.destination_m()
			if is_finite(dst_m.x) and is_finite(dst_m.y):
				var dpx := terrain_renderer.terrain_to_map(dst_m)
				draw_circle(dpx, dest_radius_px, col)
				draw_arc(dpx, dest_radius_px + 4.0, 0, TAU, 20, col, 1.2)

		if show_icons:
			var tex: Texture2D = unit.unit.icon if friend else unit.unit.enemy_icon
			if tex:
				var half := Vector2(icon_size_px, icon_size_px) * 0.5
				var mod := Color(1, 1, 1, dead_icon_alpha if unit.is_dead() else 1.0)
				draw_texture_rect(tex, Rect2(pos_m - half, half * 2.0), false, mod)
			else:
				var c := col
				if unit.is_dead():
					c.a *= dead_icon_alpha
				draw_circle(pos_m, icon_size_px * 0.5, c)

		if show_labels or show_bars:
			var y := 0.0
			var last_order_type: int = int(_last_order.get(unit.id, 0))
			var order: String
			if last_order_type > 0:
				order = OrdersParser.OrderType.keys()[last_order_type]
			var order_txt: String = order if show_orders else ""
			var beh := _enum_name(ScenarioUnit.Behaviour, unit.behaviour)
			var cmb := _enum_name(ScenarioUnit.CombatMode, unit.combat_mode)
			var s_ratio := _norm_ratio(unit.state_strength, unit.unit.strength)
			var m_ratio := _norm_ratio(unit.unit.morale)
			var fuel_ratio := (
				_fuel.get_fuel_state(unit.id).ratio()
				if show_fuel and _fuel and _fuel.get_fuel_state(unit.id)
				else -1.0
			)

			if show_labels:
				var hot := show_combat_hot and _recent_contact_until.has(unit.id)
				var lbl := (
					"%s  %s  [%s/%s]  S:%d%%  M:%d%%"
					% [
						unit.callsign,
						order_txt if order_txt != "" else _state_name(int(unit.move_state())),
						beh,
						cmb,
						int(roundi(s_ratio * 100.0)),
						int(roundi(m_ratio * 100.0))
					]
				)
				if fuel_ratio >= 0.0:
					lbl += "  F:%d%%" % roundi(fuel_ratio * 100.0)
				draw_set_transform(pos_m + label_offset_px)
				draw_string(
					get_theme_default_font(),
					Vector2.ZERO,
					lbl,
					HORIZONTAL_ALIGNMENT_LEFT,
					-1.0,
					font_size,
					hot_color if hot else text_color
				)
				draw_set_transform(Vector2(0, 0))

			if show_bars:
				var bar_w := 54.0
				var bar_h := 5.0
				var gap := 2.0
				var top := pos_m + Vector2(-bar_w * 0.5, icon_size_px * 0.5 + 4.0)
				_draw_bar(top, bar_w, bar_h, s_ratio, bar_strength)
				top.y += bar_h + gap
				_draw_bar(top, bar_w, bar_h, m_ratio, bar_morale)
				if fuel_ratio >= 0.0:
					top.y += bar_h + gap
					_draw_bar(top, bar_w, bar_h, fuel_ratio, bar_fuel)
```
