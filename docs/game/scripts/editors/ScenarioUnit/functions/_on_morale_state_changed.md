# ScenarioUnit::_on_morale_state_changed Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 75–78)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func _on_morale_state_changed(unit_id: String, prev: int, cur: int) -> void
```

## Source

```gdscript
func _on_morale_state_changed(unit_id: String, prev: int, cur: int) -> void:
	print("[%s] Morale state changed: %s → %s" % [unit_id, prev, cur])
```
