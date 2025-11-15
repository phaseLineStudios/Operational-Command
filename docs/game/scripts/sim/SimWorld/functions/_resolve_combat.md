# SimWorld::_resolve_combat Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 318–359)</br>
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
		var dmg: Variant = combat_controller.calculate_damage(a, d)
		var dmg_value := 0.0

		if typeof(dmg) == TYPE_DICTIONARY:
			dmg_value = float(dmg.get("damage", 0.0))
			var f := int(d.unit.strength * d.unit.state_strength)
			var e := int(a.unit.strength * a.unit.state_strength)
			if f != 0 or e != 0:
				Game.resolution.add_casualties(f, e)

			if bool(d.unit.state_strength == 0):
				if d.affiliation == ScenarioUnit.Affiliation.FRIEND:
					Game.resolution.add_units_lost(1)
		else:
			dmg_value = float(dmg)

		if dmg_value > 0.0:
			emit_signal("engagement_reported", a.id, d.id, dmg_value)

		# Also allow the defender to attack the attacker in the same contact tick
		if not (a == null or d == null) and not (a.is_dead() or d.is_dead()):
			var dmg2: Variant = combat_controller.calculate_damage(d, a)
			var dmg_value2 := 0.0
			if typeof(dmg2) == TYPE_DICTIONARY:
				dmg_value2 = float(dmg2.get("damage", 0.0))
			else:
				dmg_value2 = float(dmg2)
			if dmg_value2 > 0.0:
				emit_signal("engagement_reported", d.id, a.id, dmg_value2)
```

## References

- [`signal engagement_reported`](../../SimWorld.md#engagement_reported)
