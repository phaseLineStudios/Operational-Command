# MovementAgent::_on_grid_ready Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 259–263)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func _on_grid_ready(ready_profile: int) -> void
```

## Source

```gdscript
func _on_grid_ready(ready_profile: int) -> void:
	if ready_profile == profile and _moving == false and _path.size() > 0:
		pass
```
