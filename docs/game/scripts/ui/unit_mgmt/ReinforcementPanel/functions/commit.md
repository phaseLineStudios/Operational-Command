# ReinforcementPanel::commit Function Reference

*Defined at:* `scripts/ui/unit_mgmt/ReinforcementPanel.gd` (lines 114–124)</br>
*Belongs to:* [ReinforcementPanel](../../ReinforcementPanel.md)

**Signature**

```gdscript
func commit() -> void
```

## Description

Emit the current plan to the owner. Does not mutate UnitData here.

## Source

```gdscript
func commit() -> void:
	var plan: Dictionary[String, int] = _pending.duplicate(true)
	# strip any zero/negative or wiped-out entries (if units list is present)
	for uid in plan.keys():
		var u := _find_unit(uid)
		var cur_strength: float = _unit_strength.get(uid, 0.0)
		if u == null or cur_strength <= 0.0 or int(plan[uid]) <= 0:
			plan.erase(uid)
	emit_signal("reinforcement_committed", plan)
```
