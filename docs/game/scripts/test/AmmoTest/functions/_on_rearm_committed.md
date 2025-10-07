# AmmoTest::_on_rearm_committed Function Reference

*Defined at:* `scripts/test/AmmoTest.gd` (lines 262–268)</br>
*Belongs to:* [AmmoTest](../../AmmoTest.md)

**Signature**

```gdscript
func _on_rearm_committed() -> void
```

## Source

```gdscript
func _on_rearm_committed() -> void:
	# units_map like { "alpha": {"small_arms": +12, "stock:small_arms": +50} }
	# At this point UnitData has already been updated by the panel.
	# Persist your campaign state here:
	_save_campaign_state()
```
