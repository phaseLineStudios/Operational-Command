# HQTable::_on_fuel_critical Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 258–262)</br>
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
	if unit_voices and unit_voices.auto_responses:
		unit_voices.auto_responses.trigger_fuel_critical(unit_id)
```
