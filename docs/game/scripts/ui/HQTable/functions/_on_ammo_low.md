# HQTable::_on_ammo_low Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 176–180)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_ammo_low(unit_id: String) -> void
```

## Description

Handle ammo low warning.

## Source

```gdscript
func _on_ammo_low(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_ammo_low(unit_id)
```
