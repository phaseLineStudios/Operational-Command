# HQTable::_on_ammo_critical Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 182–186)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_ammo_critical(unit_id: String) -> void
```

## Description

Handle ammo critical warning.

## Source

```gdscript
func _on_ammo_critical(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_ammo_critical(unit_id)
```
