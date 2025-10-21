# UnitSelect::_show_unit_stats Function Reference

*Defined at:* `scripts/ui/UnitSelect.gd` (lines 369–379)</br>
*Belongs to:* [UnitSelect](../../UnitSelect.md)

**Signature**

```gdscript
func _show_unit_stats(unit: UnitData) -> void
```

## Description

Update stats panel with selected unit data

## Source

```gdscript
func _show_unit_stats(unit: UnitData) -> void:
	_lbl_vet.text = "Veterancy: %d" % unit.experience
	_lbl_att.text = "Attack: %d" % unit.attack
	_lbl_def.text = "Defence: %d" % unit.defense
	_lbl_spot.text = "Spotting Distance: %dm" % unit.spot_m
	_lbl_range.text = "Engagement Range: %dm" % unit.range_m
	_lbl_morale.text = "Morale: %d%%" % unit.morale
	_lbl_speed.text = "Ground Speed: %dkm/h" % unit.speed_kph
	_lbl_coh.text = "Cohesion: %d%%" % unit.cohesion
```
