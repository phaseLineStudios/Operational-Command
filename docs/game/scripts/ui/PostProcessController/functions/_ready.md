# PostProcessController::_ready Function Reference

*Defined at:* `scripts/ui/PostProcessController.gd` (lines 90–99)</br>
*Belongs to:* [PostProcessController](../../PostProcessController.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	film_grain_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	general_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	environment = world_environment.environment
	film_grain_shader = _get_shader(film_grain_rect)
	general_shader = _get_shader(general_rect)
	_apply_settings()
	_apply_read_mode(read_mode_enabled)
```
