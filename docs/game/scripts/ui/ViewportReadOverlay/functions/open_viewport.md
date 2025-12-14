# ViewportReadOverlay::open_viewport Function Reference

*Defined at:* `scripts/ui/ViewportReadOverlay.gd` (lines 33–40)</br>
*Belongs to:* [ViewportReadOverlay](../../ViewportReadOverlay.md)

**Signature**

```gdscript
func open_viewport(viewport: SubViewport, title: String = "", forward_input: bool = true) -> void
```

## Source

```gdscript
func open_viewport(viewport: SubViewport, title: String = "", forward_input: bool = true) -> void:
	_viewport = viewport
	_viewport_size = viewport.size
	forward_input_to_viewport = forward_input
	_title_label.text = title
	_texture_rect.texture = viewport.get_texture()
```
