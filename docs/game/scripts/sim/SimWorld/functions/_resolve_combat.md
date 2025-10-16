# SimWorld::_resolve_combat Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 228–255)</br>
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
		if a.is_dead() or d.is_dead():
			continue
		var dmg := combat_controller.calculate_damage(a, d)
		if dmg <= 0.0:
			continue

		emit_signal("engagement_reported", a.id, d.id)

		if typeof(dmg) == TYPE_DICTIONARY:
			var f := int(d.unit.strength * d.unit.state_strength)
			var e := int(a.unit.strength * a.unit.state_strength)
			if f != 0 or e != 0:
				Game.resolution.add_casualties(f, e)

			if bool(d.unit.state_strength == 0):
				if d.affiliation == ScenarioUnit.Affiliation.FRIEND:
					Game.resolution.add_units_lost(1)
```

## References

- [`signal engagement_reported`](..\..\SimWorld.md#engagement_reported)
