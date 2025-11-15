# HQTable::_on_fuel_low Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 229–233)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_fuel_low(unit_id: String) -> void
```

## Description

Handle fuel low warning.

## Source

```gdscript
func _on_fuel_low(unit_id: String) -> void:
	if unit_auto_voices:
		unit_auto_voices.trigger_fuel_low(unit_id)
```
