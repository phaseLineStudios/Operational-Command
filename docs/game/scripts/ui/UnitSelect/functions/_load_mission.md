# UnitSelect::_load_mission Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 93–100)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _load_mission() -> void
```

## Description

Load mission data into the UI

## Source

```gdscript
func _load_mission() -> void:
	_lbl_title.text = Game.current_scenario.title
	_total_points = Game.current_scenario.unit_points

	_build_slots()
	_build_pool()
```
