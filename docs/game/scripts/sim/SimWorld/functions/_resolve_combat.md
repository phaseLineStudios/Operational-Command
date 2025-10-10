# SimWorld::_resolve_combat Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 157–171)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _resolve_combat() -> void
```

## Description

Resolves combat for current contact pairs (range/logic inside controller).
Emits `signal engagement_reported` for damage > 0.

## Source

```gdscript
func _resolve_combat() -> void:
	if combat_controller == null:
		return
	for key in _last_contacts:
		var parts := key.split("|")
		var a: ScenarioUnit = _units_by_id.get(parts[0])
		var d: ScenarioUnit = _units_by_id.get(parts[1])
		if a == null or d == null:
			continue

		var dmg := combat_controller.calculate_damage(a, d)
		if dmg > 0.0:
			emit_signal("engagement_reported", a.id, d.id)
```

## References

- [`signal engagement_reported`](..\..\SimWorld.md#engagement_reported)
