# MapController::_on_renderer_ready Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 218–221)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _on_renderer_ready() -> void
```

## Description

Renderer ready callback: generate mipmaps after initial render completes

## Source

```gdscript
func _on_renderer_ready() -> void:
	_update_mipmap_texture()
```
