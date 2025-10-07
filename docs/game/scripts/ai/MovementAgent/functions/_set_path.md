# MovementAgent::_set_path Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 136–143)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _set_path(p: PackedVector2Array) -> void
```

## Source

```gdscript
func _set_path(p: PackedVector2Array) -> void:
	_path = p
	_path_idx = 0
	_moving = true
	emit_signal("path_updated", _path)
	emit_signal("movement_started")
```
