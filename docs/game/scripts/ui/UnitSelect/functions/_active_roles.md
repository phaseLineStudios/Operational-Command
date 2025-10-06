# UnitSelect::_active_roles Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 166–182)</br>
*Belongs to:* [UnitSelect](../UnitSelect.md)

**Signature**

```gdscript
func _active_roles() -> PackedStringArray
```

## Description

Collect roles enabled in current filter

## Source

```gdscript
func _active_roles() -> PackedStringArray:
	if _filter_all.button_pressed:
		return []
	var wanted: PackedStringArray = []
	if _filter_armor.button_pressed:
		wanted.append("ARMOR")
	if _filter_inf.button_pressed:
		wanted.append("INF")
	if _filter_mech.button_pressed:
		wanted.append("MECH")
	if _filter_motor.button_pressed:
		wanted.append("MOTOR")
	if _filter_support.button_pressed:
		wanted.append("SUPPORT")
	return wanted
```
