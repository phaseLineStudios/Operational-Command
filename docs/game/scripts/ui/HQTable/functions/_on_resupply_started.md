# HQTable::_on_resupply_started Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 263–267)</br>
*Belongs to:* [HQTable](../../HQTable.md)

**Signature**

```gdscript
func _on_resupply_started(src_unit_id: String, dst_unit_id: String) -> void
```

## Description

Handle resupply started.

## Source

```gdscript
func _on_resupply_started(src_unit_id: String, dst_unit_id: String) -> void:
	if unit_voices and unit_voices.auto_responses:
		unit_voices.auto_responses.trigger_resupply_started(src_unit_id, dst_unit_id)
```
