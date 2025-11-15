# AIAgent::intent_defend_check Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 181–188)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func intent_defend_check() -> bool
```

## Source

```gdscript
func intent_defend_check() -> bool:
	var su := _get_su()
	if su == null:
		return true
	# Consider defend established when unit is idle (arrived or holding)
	return su.move_state() in [ScenarioUnit.MoveState.ARRIVED, ScenarioUnit.MoveState.IDLE]
```
