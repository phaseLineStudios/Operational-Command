# UnitSelect::_refresh_topbar Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 307–312)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _refresh_topbar() -> void
```

## Description

Update topbar with used slots and points

## Source

```gdscript
func _refresh_topbar() -> void:
	var used_slots := _assigned_by_unit.size()
	_lbl_slots.text = "Slots %d/%d" % [used_slots, _total_slots]
	_lbl_points.text = "Points: %d/%d" % [_total_points - _used_points, _total_points]
```
