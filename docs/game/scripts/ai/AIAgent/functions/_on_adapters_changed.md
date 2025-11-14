# AIAgent::_on_adapters_changed Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 65–70)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func _on_adapters_changed() -> void
```

## Source

```gdscript
func _on_adapters_changed() -> void:
	_apply_behaviour_mapping()
	if _combat != null:
		_combat.set_rules_of_engagement(combat_mode)
```
