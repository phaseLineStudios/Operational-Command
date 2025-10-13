# UnitSelect::_recompute_logistics Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 314–335)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _recompute_logistics() -> void
```

## Description

Recalculate logistics totals from assigned units

## Source

```gdscript
func _recompute_logistics() -> void:
	var equipment := 0
	var fuel := 0
	var medical := 0
	var repair := 0

	for unit_id in _assigned_by_unit.keys():
		var u: UnitData = _units_by_id[unit_id]
		var thr: Dictionary = u.throughput

		if thr.has("equipment"):
			equipment += int(thr["equipment"])
		if thr.has("fuel"):
			fuel += int(thr["fuel"])
		if thr.has("medical"):
			medical += int(thr["medical"])
		if thr.has("repair"):
			repair += int(thr["repair"])

	_update_logistics_labels(equipment, fuel, medical, repair)
```
