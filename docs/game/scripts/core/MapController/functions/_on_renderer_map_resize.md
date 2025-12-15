# MapController::_on_renderer_map_resize Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 460–463)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _on_renderer_map_resize() -> void
```

## Description

Renderer callback: sync viewport to new map pixel size

## Source

```gdscript
func _on_renderer_map_resize() -> void:
	_update_viewport_to_renderer()
```
