# Settings::_schedule_render_scale_apply Function Reference

*Defined at:* `scripts/ui/Settings.gd` (lines 376–387)</br>
*Belongs to:* [Settings](../../Settings.md)

**Signature**

```gdscript
func _schedule_render_scale_apply() -> void
```

## Source

```gdscript
func _schedule_render_scale_apply() -> void:
	var window := get_window()
	if window == null:
		call_deferred("_apply_render_scale")
		return

	var cb := Callable(self, "_apply_render_scale")
	if not window.size_changed.is_connected(cb):
		window.size_changed.connect(cb, CONNECT_ONE_SHOT)
	call_deferred("_apply_render_scale")
```
