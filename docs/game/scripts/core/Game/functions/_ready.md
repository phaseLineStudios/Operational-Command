# Game::_ready Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 51–65)</br>
*Belongs to:* [Game](../../Game.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	debug_display = debug_display_scene.instantiate()
	get_tree().root.add_child.call_deferred(debug_display)

	var root_viewport := get_tree().root
	_base_msaa_3d = root_viewport.msaa_3d if root_viewport else -1

	var window := get_window()
	if window:
		var cb := Callable(self, "_on_window_size_changed")
		if not window.size_changed.is_connected(cb):
			window.size_changed.connect(cb)
	_on_window_size_changed()
```
