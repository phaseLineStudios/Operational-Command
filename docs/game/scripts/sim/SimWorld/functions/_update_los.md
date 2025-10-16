# SimWorld::_update_los Function Reference

*Defined at:* `scripts/sim/SimWorld.gd` (lines 209–225)</br>
*Belongs to:* [SimWorld](../../SimWorld.md)

**Signature**

```gdscript
func _update_los() -> void
```

## Description

Computes LOS contact pairs once per tick and emits contact events.

## Source

```gdscript
func _update_los() -> void:
	if los_adapter == null:
		return
	var pairs := los_adapter.contacts_between(_friendlies, _enemies)
	_last_contacts.clear()
	_contact_pairs.clear()
	for p in pairs:
		var a: ScenarioUnit = p.attacker
		var d: ScenarioUnit = p.defender
		if a.is_dead() or d.is_dead():
			continue
		var key := "%s|%s" % [a.id, d.id]
		_last_contacts.append(key)
		_contact_pairs.append({"attacker": a.id, "defender": d.id})
		emit_signal("contact_reported", a.id, d.id)
```
