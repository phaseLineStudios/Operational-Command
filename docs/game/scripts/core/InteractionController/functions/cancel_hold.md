# InteractionController::cancel_hold Function Reference

*Defined at:* `scripts/core/PlayerInteraction.gd` (lines 151–157)</br>
*Belongs to:* [InteractionController](../../InteractionController.md)

**Signature**

```gdscript
func cancel_hold() -> void
```

## Source

```gdscript
func cancel_hold() -> void:
	if _held != null:
		if _held.is_inspecting():
			_held.end_inspect()
		_drop_held()
```
