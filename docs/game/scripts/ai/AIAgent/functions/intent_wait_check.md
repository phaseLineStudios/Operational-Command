# AIAgent::intent_wait_check Function Reference

*Defined at:* `scripts/ai/AIAgent.gd` (lines 213–227)</br>
*Belongs to:* [AIAgent](../../AIAgent.md)

**Signature**

```gdscript
func intent_wait_check(dt: float) -> bool
```

## Source

```gdscript
func intent_wait_check(dt: float) -> bool:
	if _wait_until_contact:
		if _los != null and _los.has_hostile_contact():
			_wait_timer = 0.0
			return true
		# Fallback to SimWorld contacts
		var su: ScenarioUnit = _get_su()
		var sim: SimWorld = get_tree().get_root().find_child("SimWorld", true, false)
		if su and sim and sim.has_method("get_contacts_for_unit"):
			var contacts: Array = sim.get_contacts_for_unit(su.id)
			if contacts.size() > 0:
				_wait_timer = 0.0
				return true
	_wait_timer = max(_wait_timer - dt, 0.0)
	return _wait_timer <= 0.0
```
