# HQTable::_on_fuel_critical Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 235–239)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_fuel_critical(unit_id: String) -> void
```

## Description

Handle fuel critical warning.

## Source

```gdscript
func _on_fuel_critical(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_fuel_critical(unit_id)
```
