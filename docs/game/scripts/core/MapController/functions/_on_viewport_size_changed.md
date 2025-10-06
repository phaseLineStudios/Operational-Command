# MapController::_on_viewport_size_changed Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 122–126)</br>
*Belongs to:* [MapController](../MapController.md)

**Signature**

```gdscript
func _on_viewport_size_changed() -> void
```

## Description

Viewport callback: refit plane on texture size change

## Source

```gdscript
func _on_viewport_size_changed() -> void:
	_apply_viewport_texture()
	_update_mesh_fit()
```
