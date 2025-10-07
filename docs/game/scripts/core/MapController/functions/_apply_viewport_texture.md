# MapController::_apply_viewport_texture Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 76–79)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _apply_viewport_texture() -> void
```

## Description

Assign the terrain viewport as the map texture

## Source

```gdscript
func _apply_viewport_texture() -> void:
	_mat.albedo_texture = terrain_viewport.get_texture()
```
