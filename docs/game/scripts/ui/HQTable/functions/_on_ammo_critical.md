# HQTable::_on_ammo_critical Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 245–249)</br>
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
	if unit_voices and unit_voices.auto_responses:
		unit_voices.auto_responses.trigger_ammo_critical(unit_id)
```
