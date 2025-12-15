# MapController::_schedule_mipmap_update Function Reference

*Defined at:* `scripts/core/MapController.gd` (lines 278–292)</br>
*Belongs to:* [MapController](../../MapController.md)

**Signature**

```gdscript
func _schedule_mipmap_update() -> void
```

## Description

Debounce mipmap rebuilds and ensure the map gets baked back to a static ImageTexture.

## Source

```gdscript
func _schedule_mipmap_update() -> void:
	if not bake_viewport_mipmaps:
		return
	if _is_dynamic_viewport() or not is_inside_tree():
		return
	_mipmap_gen += 1
	if _mipmap_timer != null:
		return
	var delay_sec: float = mipmap_update_delay_sec
	if delay_sec < 0.0:
		delay_sec = 0.0
	_mipmap_timer = get_tree().create_timer(delay_sec)
	_mipmap_timer.timeout.connect(_on_mipmap_timer_timeout)
```
