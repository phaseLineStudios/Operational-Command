# DebugOverlay::_draw_unit_glyphs Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 59–125)</br>
*Belongs to:* [DebugOverlay](../DebugOverlay.md)

**Signature**

```gdscript
func _draw_unit_glyphs(su: ScenarioUnit, _idx: int) -> void
```

## Source

```gdscript
func _draw_unit_glyphs(su: ScenarioUnit, _idx: int) -> void:
	var p := _screen_from_m(su.position_m)
	var tex := _icon_for_unit(su)

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
```
