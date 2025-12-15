# MapController::_apply_map_material_settings Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 184–192)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _apply_map_material_settings() -> void
```

## Source

```gdscript
func _apply_map_material_settings() -> void:
	if _map_mat == null:
		return
	_map_mat.set_shader_parameter("brightness", clampf(map_brightness, 0.0, 1.0))
	_map_mat.set_shader_parameter("contrast", maxf(map_contrast, 0.0))
	_map_mat.set_shader_parameter("sharpen_strength", maxf(map_sharpen_strength, 0.0))
	_map_mat.set_shader_parameter("unshaded", 1.0 if map_unshaded else 0.0)
```
