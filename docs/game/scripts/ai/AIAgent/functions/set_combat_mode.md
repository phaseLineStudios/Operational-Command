# AIAgent::set_combat_mode Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 96–106)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func set_combat_mode(m: int) -> void
```

## Source

```gdscript
func set_combat_mode(m: int) -> void:
	combat_mode = m
	emit_signal("combat_mode_changed", unit_id, combat_mode)
	if _combat != null:
		_combat.set_rules_of_engagement(combat_mode)
	# Also write through to the ScenarioUnit so CombatController uses updated ROE
	var su := _get_su()
	if su:
		su.combat_mode = int(combat_mode) as ScenarioUnit.CombatMode
```
