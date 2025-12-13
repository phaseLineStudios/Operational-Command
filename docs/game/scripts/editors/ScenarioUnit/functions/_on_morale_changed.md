# ScenarioUnit::_on_morale_changed Function Reference

*Defined at:* `scripts/editors/ScenarioUnit.gd` (lines 84–88)</br>
*Belongs to:* [ScenarioUnit](../../ScenarioUnit.md)

**Signature**

```gdscript
func _on_morale_changed(unit_id: String, prev: float, cur: float, source: String) -> void
```

## Source

```gdscript
func _on_morale_changed(unit_id: String, prev: float, cur: float, source: String) -> void:
	print("[%s] Morale changed from %.2f → %.2f (source: %s)" % [unit_id, prev, cur, source])
	_morale = _morale_sys.get_morale()
```
