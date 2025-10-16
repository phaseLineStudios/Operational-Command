# SimDebugOverlay::_draw_bar Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 325–331)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void
```

- **tl**: Top-left in overlay pixels.
- **w**: Width (px).
- **h**: Height (px).
- **ratio**: Fill ratio [0..1].
- **col**: Fill color.

## Description

Draw a ratio bar with background and thin border.

## Source

```gdscript
func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	draw_rect(Rect2(tl, Vector2(w, h)), bar_bg, true)
	draw_rect(Rect2(tl, Vector2(w * ratio, h)), col, true)
	draw_rect(Rect2(tl, Vector2(w, h)), Color(0, 0, 0, 0.65), false, 1.0)
```
