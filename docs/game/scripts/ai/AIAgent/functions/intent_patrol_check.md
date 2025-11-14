# AIAgent::intent_patrol_check Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 196–201)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func intent_patrol_check() -> bool
```

## Source

```gdscript
func intent_patrol_check() -> bool:
	if _movement == null:
		return true
	return not bool(_movement.is_patrol_running())
```
