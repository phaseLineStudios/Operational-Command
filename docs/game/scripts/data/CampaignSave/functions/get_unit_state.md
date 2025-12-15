# CampaignSave::get_unit_state Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 112–115)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func get_unit_state(unit_id: String) -> Dictionary
```

## Description

Get unit state for a unit, or empty dict if not found.

## Source

```gdscript
func get_unit_state(unit_id: String) -> Dictionary:
	return unit_states.get(unit_id, {})
```
