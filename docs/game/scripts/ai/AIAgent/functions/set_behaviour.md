# AIAgent::set_behaviour Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 86–95)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func set_behaviour(b: int) -> void
```

## Source

```gdscript
func set_behaviour(b: int) -> void:
	behaviour = b
	emit_signal("behaviour_changed", unit_id, behaviour)
	_apply_behaviour_mapping()
	# Also write through to the ScenarioUnit so simulation logic sees it
	var su := _get_su()
	if su:
		su.behaviour = int(behaviour) as ScenarioUnit.Behaviour
```
