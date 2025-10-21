# MovementAgent::stop Function Reference

*Defined at:* `scripts/ai/MovementAgent.gd` (lines 235–240)</br>
*Belongs to:* [MovementAgent](../../MovementAgent.md)

**Signature**

```gdscript
func stop() -> void
```

## Description

Command stop immediately.

## Source

```gdscript
func stop() -> void:
	_moving = false
	_path = []
	_path_idx = 0
```
