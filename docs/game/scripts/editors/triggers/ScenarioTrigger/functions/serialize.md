# ScenarioTrigger::serialize Function Reference

*Defined at:* `scripts/editors/triggers/ScenarioTrigger.gd` (lines 52–68)</br>
*Belongs to:* [ScenarioTrigger](../../ScenarioTrigger.md)

**Signature**

```gdscript
func serialize() -> Dictionary
```

## Source

```gdscript
func serialize() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"area_center_m": ContentDB.v2(area_center_m),
		"shape": int(area_shape),
		"size_m": ContentDB.v2(area_size_m),
		"presence": int(presence),
		"require_duration_s": require_duration_s,
		"condition_expr": condition_expr,
		"on_activate_expr": on_activate_expr,
		"on_deactivate_expr": on_deactivate_expr,
		"synced_units": synced_units.duplicate(),
		"synced_tasks": synced_tasks.duplicate(),
	}
```
