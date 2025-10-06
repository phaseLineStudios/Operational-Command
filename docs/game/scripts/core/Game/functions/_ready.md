# Game::_ready Function Reference

*Defined at:* `scripts/core/Game.gd` (lines 33–37)</br>
*Belongs to:* [Game](../Game.md)

**Signature**

```gdscript
func _ready() -> void
```

## Source

```gdscript
func _ready() -> void:
	debug_display = debug_display_scene.instantiate()
	get_tree().root.add_child.call_deferred(debug_display)
```
