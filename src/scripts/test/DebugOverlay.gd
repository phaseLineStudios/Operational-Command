extends Control
## Tactical debug overlay: icons, status bars, LOS line and a text panel.
## Now also shows fuel levels and applied speed penalties via FuelSystem.

## Toggles
@export var show_text := true
@export var show_bars := true
@export var show_los := true
@export var show_icons := true
@export var show_fuel_text := true  ## show fuel line in the panel

## Style
@export var font_size := 12
@export var icon_size_px := 28
@export var icon_halo := true
@export var halo_color := Color(1, 1, 1, 0.8)

@export var panel_offset := Vector2(40, -10)
@export var panel_pad := Vector2(10, 10)

var _renderer: TerrainRender
var _units: Array[ScenarioUnit] = []
var _dbg: Dictionary = {}
var _fuel: FuelSystem = null  ## resolved automatically or via set_fuel_system()


## Set up overlay with renderer and the two scenario units [attacker, defender].
func setup_overlay(renderer: TerrainRender, units: Array[ScenarioUnit], player_units: Array[ScenarioUnit] = []) -> void:
	_renderer = renderer
	units.append_array(player_units)
	_units = units

	if _fuel == null:
		_fuel = get_tree().get_first_node_in_group("FuelSystem") as FuelSystem

	queue_redraw()


## Optionally bind FuelSystem explicitly if you do not use the group.
func set_fuel_system(fs: FuelSystem) -> void:
	_fuel = fs
	queue_redraw()


func update_debug(d: Dictionary) -> void:
	_dbg = d
	queue_redraw()


func _draw() -> void:
	if _renderer == null:
		return

	if show_icons or show_bars:
		var idx := 0
		for su in _units:
			if su == null:
				idx += 1
				continue
			_draw_unit_glyphs(su, idx)
			idx += 1

	if show_los and _dbg.has("attacker") and _dbg.has("defender"):
		var a := _screen_from_m(_dbg.attacker.pos_m)
		var b := _screen_from_m(_dbg.defender.pos_m)
		var col := (
			Color(0.05, 0.8, 0.2, 0.9)
			if not bool(_dbg.get("blocked", false))
			else Color(0.9, 0.2, 0.2, 0.9)
		)
		draw_line(a, b, col, 2.0)

	if show_text and not _dbg.is_empty():
		_draw_text_panel(_dbg)


func _draw_unit_glyphs(su: ScenarioUnit, _idx: int) -> void:
	var p: Vector2 = _screen_from_m(su.position_m)
	var tex: Texture2D = _icon_for_unit(su)

	if show_icons:
		if icon_halo:
			draw_circle(p + Vector2(0, 1), icon_size_px * 0.45, halo_color)
		if tex != null:
			var sz := Vector2(icon_size_px, icon_size_px)
			draw_texture_rect(tex, Rect2(p - sz * 0.5, sz), false)

	if show_bars and su.unit:
		var w := 60.0
		var h := 5.0
		var s_t := 0.0
		var m_t := 0.0
		if _dbg.has("attacker") and su == _units[0]:
			s_t = clamp(float(_dbg.attacker.strength) / float(max(su.unit.strength, 1)), 0.0, 1.0)
			m_t = clamp(float(_dbg.attacker.morale), 0.0, 1.0)
		elif _dbg.has("defender") and su == _units[1]:
			s_t = clamp(float(_dbg.defender.strength) / float(max(su.unit.strength, 1)), 0.0, 1.0)
			m_t = clamp(float(_dbg.defender.morale), 0.0, 1.0)
		if s_t == 0.0 and m_t == 0.0:
			s_t = clamp(
				(
					(
						su.unit.state_strength
						if su.unit.state_strength > 0.0
						else float(su.unit.strength)
					)
					/ float(max(su.unit.strength, 1))
				),
				0.0,
				1.0
			)
			m_t = clamp(su.unit.morale, 0.0, 1.0)
		draw_rect(Rect2(p + Vector2(-w * 0.5, -20), Vector2(w, h)), Color(0, 0, 0, 0.5), true)
		draw_rect(
			Rect2(p + Vector2(-w * 0.5, -20), Vector2(w * s_t, h)),
			Color(0.15, 0.7, 0.2, 0.95),
			true
		)
		draw_rect(Rect2(p + Vector2(-w * 0.5, -12), Vector2(w, h)), Color(0, 0, 0, 0.5), true)
		draw_rect(
			Rect2(p + Vector2(-w * 0.5, -12), Vector2(w * m_t, h)), Color(0.2, 0.4, 1.0, 0.85), true
		)

		var label := (
			su.callsign
			if su.callsign != ""
			else (su.id if su.id != "" else (su.unit.id if su.unit else ""))
		)
		if label != "":
			var f := get_theme_default_font()
			var sz := f.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
			var label_pos := p + Vector2(-sz.x * 0.5, -20 - 6)  # above top bar (-20), with small gap
			draw_string(
				f,
				label_pos,
				label,
				HORIZONTAL_ALIGNMENT_LEFT,
				-1.0,
				font_size,
				Color(0, 0, 0, 0.95)
			)


func _icon_for_unit(su: ScenarioUnit) -> Texture2D:
	if su == null or su.unit == null:
		return null
	var aff: ScenarioUnit.Affiliation = (
		su.affiliation if "affiliation" in su else ScenarioUnit.Affiliation.FRIEND
	)
	return (
		su.unit.icon
		if int(aff) == int(ScenarioUnit.Affiliation.FRIEND)
		else (su.unit.enemy_icon if su.unit.enemy_icon != null else su.unit.icon)
	)


func _draw_text_panel(d: Dictionary) -> void:
	var f := get_theme_default_font()
	var lines := PackedStringArray()

	lines.append(
		(
			"r=%.0fm  LOS=%s  @res=%s"
			% [
				float(d.get("range_m", 0.0)),
				str(!d.get("blocked", false)),
				str(d.get("at_resolution", false))
			]
		)
	)
	lines.append(
		(
			"ACC=%.2f  DMG=%.2f  SPT=%.2f"
			% [
				float(d.get("accuracy_mul", 1.0)),
				float(d.get("damage_mul", 1.0)),
				float(d.get("spotting_mul", 1.0))
			]
		)
	)
	var c: Variant = d.get("components", {})
	lines.append(
		(
			"dh=%.1f  cover=%.2f  conceal=%.2f  atten=%.2f  wx=%.2f"
			% [
				float(c.get("dh_m", 0.0)),
				float(c.get("cover", 0.0)),
				float(c.get("conceal", 0.0)),
				float(c.get("atten_integral", 0.0)),
				float(c.get("weather_severity", 0.0))
			]
		)
	)
	lines.append(
		(
			"ATK base=%.1f → %.1f | DEF base=%.1f → %.1f"
			% [
				float(d.get("base_attack", 0.0)),
				float(d.get("attackpower", 0.0)),
				float(d.get("base_defense", 0.0)),
				float(d.get("defensepower", 0.0))
			]
		)
	)
	if d.has("attacker") and d.has("defender"):
		lines.append(
			(
				"%s S%.0f/M%.2f  vs  %s S%.0f/M%.2f"
				% [
					String(d.attacker.cs),
					float(d.attacker.strength),
					float(d.attacker.morale),
					String(d.defender.cs),
					float(d.defender.strength),
					float(d.defender.morale)
				]
			)
		)

	## Fuel line
	if show_fuel_text and _fuel != null and _units.size() >= 2:
		var atk: ScenarioUnit = _units[0]
		var def: ScenarioUnit = _units[1]
		lines.append(_format_fuel_line(atk, def))

	## Panel sizing and draw
	var w := 0.0
	for line in lines:
		w = max(w, f.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x)
	var h := (font_size + 2.0) * float(lines.size())
	var panel_size := Vector2(w + panel_pad.x * 2.0, h + panel_pad.y * 2.0)

	var anchor := Vector2(panel_pad.x, panel_pad.y)
	if d.has("attacker") and d.has("defender"):
		var a := _screen_from_m(d.attacker.pos_m)
		var b := _screen_from_m(d.defender.pos_m)
		anchor = (a + b) * 0.5 + panel_offset

	var tl := Vector2(
		clamp(anchor.x, 0.0, size.x - panel_size.x), clamp(anchor.y, 0.0, size.y - panel_size.y)
	)
	var panel := Rect2(tl, panel_size)

	draw_rect(panel, Color(1, 1, 1, 0.85), true)
	var y := tl.y + panel_pad.y
	for line in lines:
		draw_string(
			f,
			Vector2(tl.x + panel_pad.x, y),
			line,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1.0,
			font_size,
			Color(0, 0, 0, 0.95)
		)
		y += font_size + 2.0


func _format_fuel_line(atk: ScenarioUnit, def: ScenarioUnit) -> String:
	var atk_s := _fuel_snapshot(atk)
	var def_s := _fuel_snapshot(def)
	return "FUEL atk %s | def %s" % [atk_s, def_s]


## Build "68% LOW x0.85 (-15%)" style snippets per unit.
func _fuel_snapshot(su: ScenarioUnit) -> String:
	if su == null or _fuel == null:
		return "n/a x1.00 (-0%)"
	var st: UnitFuelState = _fuel.get_fuel_state(su.id)
	if st == null:
		return "n/a x1.00 (-0%)"

	var pct: int = int(round(st.ratio() * 100.0))
	var mult: float = _fuel.speed_mult(su.id)
	var pen: int = int(round((1.0 - mult) * 100.0))
	var tag := "OK"
	if _fuel.is_empty(su.id):
		tag = "EMPTY"
	elif _fuel.is_critical(su.id):
		tag = "CRIT"
	elif _fuel.is_low(su.id):
		tag = "LOW"

	return "%d%% %s x%.2f (-%d%%)" % [pct, tag, mult, pen]


func _screen_from_m(pos_m: Vector2) -> Vector2:
	var map_local := _renderer.terrain_to_map(pos_m)
	return _renderer.global_position + map_local
