# SimDebugOverlay::_draw_bar Function Reference

*Defined at:* `scripts/sim/SimDebugOverlay.gd` (lines 296–302)</br>
*Belongs to:* [SimDebugOverlay](../../SimDebugOverlay.md)

**Signature**

```gdscript
func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void
```

## Description

Draw a ratio bar with background and thin border.
[param tl] Top-left in overlay pixels.
[param w] Width (px).
[param h] Height (px).
[param ratio] Fill ratio [0..1].
[param col] Fill color.

## Source

```gdscript
func _draw_bar(tl: Vector2, w: float, h: float, ratio: float, col: Color) -> void:
	ratio = clampf(ratio, 0.0, 1.0)
	draw_rect(Rect2(tl, Vector2(w, h)), bar_bg, true)
	draw_rect(Rect2(tl, Vector2(w * ratio, h)), col, true)
	draw_rect(Rect2(tl, Vector2(w, h)), Color(0, 0, 0, 0.65), false, 1.0)
```
