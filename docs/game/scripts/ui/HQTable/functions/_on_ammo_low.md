# HQTable::_on_ammo_low Function Reference

*Defined at:* `scripts/ui/HQTable.gd` (lines 239–243)</br>
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
	if unit_voices and unit_voices.auto_responses:
		unit_voices.auto_responses.trigger_ammo_low(unit_id)
```
