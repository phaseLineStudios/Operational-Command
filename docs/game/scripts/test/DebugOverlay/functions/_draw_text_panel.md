# DebugOverlay::_draw_text_panel Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 162–263)</br>
*Belongs to:* [DebugOverlay](../../DebugOverlay.md)

**Signature**

```gdscript
func _draw_text_panel(d: Dictionary) -> void
```

## Source

```gdscript
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
```
