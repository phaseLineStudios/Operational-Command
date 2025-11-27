# AIAgent::intent_move_check Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 160–166)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func intent_move_check() -> bool
```

## Source

```gdscript
func intent_move_check() -> bool:
	var su := _get_su()
	if su == null:
		return true
	return su.move_state() == ScenarioUnit.MoveState.ARRIVED
```
