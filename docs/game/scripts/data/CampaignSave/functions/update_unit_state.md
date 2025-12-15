# CampaignSave::update_unit_state Function Reference

*Defined at:* `scripts/data/CampaignSave.gd` (lines 107–110)</br>
*Belongs to:* [CampaignSave](../../CampaignSave.md)

**Signature**

```gdscript
func update_unit_state(unit_id: String, state: Dictionary) -> void
```

- **unit_id**: The unit ID.
- **state**: Dictionary with state keys: state_strength, state_injured,

## Description

Update unit state for a unit.
state_equipment, cohesion, state_ammunition.

## Source

```gdscript
func update_unit_state(unit_id: String, state: Dictionary) -> void:
	unit_states[unit_id] = state.duplicate()
```
