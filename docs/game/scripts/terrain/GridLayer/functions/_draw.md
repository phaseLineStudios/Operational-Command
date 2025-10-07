# GridLayer::_draw Function Reference

*Defined at:* `scripts/terrain/GridLayer.gd` (lines 47–55)</br>
*Belongs to:* [GridLayer](../../GridLayer.md)

**Signature**

```gdscript
func _draw()
```

## Source

```gdscript
func _draw():
	if data == null:
		return
	if _need_bake:
		_bake_grid_texture()
	if _grid_tex:
		draw_texture_rect(_grid_tex, Rect2(Vector2.ZERO, size), false)
```
