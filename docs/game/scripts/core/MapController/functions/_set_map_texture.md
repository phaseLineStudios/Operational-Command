# MapController::_set_map_texture Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 210–215)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _set_map_texture(tex: Texture2D) -> void
```

## Source

```gdscript
func _set_map_texture(tex: Texture2D) -> void:
	if _map_mat == null:
		return
	_map_mat.set_shader_parameter("map_tex", tex)
```
