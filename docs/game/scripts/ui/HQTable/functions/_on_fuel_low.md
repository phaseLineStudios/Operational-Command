# HQTable::_on_fuel_low Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 251–255)</br>
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
	if unit_voices and unit_voices.auto_responses:
		unit_voices.auto_responses.trigger_fuel_low(unit_id)
```
