# FuelRefuelPanel::_on_commit Function Reference

*Defined at:* `scripts/ui/FuelRefuelPanel.gd` (lines 167–198)</br>
*Belongs to:* [FuelRefuelPanel](../../FuelRefuelPanel.md)

**Signature**

```gdscript
func _on_commit() -> void
```

## Source

```gdscript
func _on_commit() -> void:
	if _fuel == null:
		hide()
		return

	var plan: Dictionary[String, float] = {}
	var requested: float = 0.0
	for key in _sliders.keys():
		var id: String = key as String
		var amount: float = float(_sliders[id].value)
		if amount > 0.0:
			plan[id] = amount
			requested += amount

	var spend: float = min(requested, _depot)
	var left_to_spend: float = spend

	for key in plan.keys():
		var uid: String = key as String
		if left_to_spend <= 0.0:
			break
		var want: float = min(float(plan[uid]), left_to_spend)
		var added: float = _apply_refuel(uid, want)
		left_to_spend -= added

	_depot = max(0.0, _depot - spend + left_to_spend)
	_update_depot_label()

	emit_signal("refuel_committed", plan, _depot)
	hide()
```
