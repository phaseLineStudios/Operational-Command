# ViewportReadOverlay::open_texture Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 41–48)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func open_texture(texture: Texture2D, title: String = "") -> void
```

## Source

```gdscript
func open_texture(texture: Texture2D, title: String = "") -> void:
	_viewport = null
	_viewport_size = Vector2i.ZERO
	forward_input_to_viewport = false
	_title_label.text = title
	_texture_rect.texture = texture
```
