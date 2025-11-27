# InteractionController::_drop_held Function Reference

*Defined at:* `scripts/core/PlayerInteraction.gd` (lines 125–132)</br>
*Belongs to:* [InteractionController](../../InteractionController.md)

**Signature**

```gdscript
func _drop_held() -> void
```

## Source

```gdscript
func _drop_held() -> void:
	if _held != null:
		if _held.has_method("on_drop"):
			_held.call("on_drop")
	_held = null
	_have_valid_plane_point = false
```
