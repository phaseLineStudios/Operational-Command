# HQTable::_on_fuel_supplier_exhausted Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 281–285)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_fuel_supplier_exhausted(src_unit_id: String) -> void
```

## Description

Handle fuel supplier exhausted.

## Source

```gdscript
func _on_fuel_supplier_exhausted(src_unit_id: String) -> void:
	if unit_voices and unit_voices.auto_responses:
		unit_voices.auto_responses.trigger_refuel_exhausted(src_unit_id)
```
