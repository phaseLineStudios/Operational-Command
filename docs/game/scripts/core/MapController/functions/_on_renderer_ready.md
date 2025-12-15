# MapController::_on_renderer_ready Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 470–473)</br>
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
	_request_map_refresh(true)
```
