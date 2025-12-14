# UnitCreateDialog::_update_attack_preview Function Reference

*Defined at:* `scripts/editors/UnitCreateDialog.gd` (lines 269–282)</br>
*Belongs to:* [UnitCreateDialog](../../UnitCreateDialog.md)

**Signature**

```gdscript
func _update_attack_preview() -> void
```

## Source

```gdscript
func _update_attack_preview() -> void:
	if _attack_value == null:
		return
	var base_unit: UnitData = _working if _working != null else UnitData.new()
	var preview := base_unit.duplicate(true) as UnitData
	preview.strength = int(_strength.value)
	preview.morale = clamp(float(_morale.value), 0.0, 1.0)
	preview.equipment = _equip.duplicate(true)
	preview.ammunition = _gather_ammo_from_inputs()
	var current_strength := float(_strength.value)
	preview.compute_attack_power(AMMO_DAMAGE_CONFIG, current_strength)
	_attack_value.text = "%.1f" % preview.attack
```
