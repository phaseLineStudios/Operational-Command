# HQTable::_on_refuel_started Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 275–279)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_refuel_started(src_unit_id: String, dst_unit_id: String) -> void
```

## Description

Handle refuel started.

## Source

```gdscript
func _on_refuel_started(src_unit_id: String, dst_unit_id: String) -> void:
	if unit_voices and unit_voices.auto_responses:
		unit_voices.auto_responses.trigger_refuel_started(src_unit_id, dst_unit_id)
```
