# TriggerAPI::is_unit_destroyed Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 479–485)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func is_unit_destroyed(id_or_callsign: String) -> bool
```

- **id_or_callsign**: Unit ID or callsign to check.
- **Return Value**: True if unit is destroyed/dead, false if alive or not found.

## Description

Check if a unit is destroyed (wiped out, state_strength == 0).
Returns true if the unit is dead or has zero strength.
  
  

**Usage in trigger expressions:**

```
# Trigger when ALPHA is destroyed
is_unit_destroyed("ALPHA")

# Check for unit destruction and complete objective
if is_unit_destroyed("ENEMY_1"):
complete_objective("destroy_enemy")
radio("Enemy unit eliminated!")

# Tutorial: explain unit loss
if is_unit_destroyed("ALPHA") and not has_global("unit_loss_tutorial_shown"):
set_global("unit_loss_tutorial_shown", true)
show_dialog("Your unit has been destroyed!", true)
```

## Source

```gdscript
func is_unit_destroyed(id_or_callsign: String) -> bool:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return false
	return unit_data.get("dead", false)
```
