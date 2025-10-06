# DebugOverlay::_draw Function Reference

*Defined at:* `scripts/test/DebugOverlay.gd` (lines 32–58)</br>
*Belongs to:* [DebugOverlay](../DebugOverlay.md)

**Signature**

```gdscript
func _draw() -> void
```

## Source

```gdscript
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
```
