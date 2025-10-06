# MovementAgent::_debug_push_trail Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 150–158)</br>
*Belongs to:* [MovementAgent](../MovementAgent.md)

**Signature**

```gdscript
func _debug_push_trail() -> void
```

## Description

Push current position into the breadcrumb list.

## Source

```gdscript
func _debug_push_trail() -> void:
	if debug_trail_len <= 0:
		return
	var here_m := sim_pos_m
	_trail.append(here_m)
	if _trail.size() > debug_trail_len:
		_trail.remove_at(0)
```
