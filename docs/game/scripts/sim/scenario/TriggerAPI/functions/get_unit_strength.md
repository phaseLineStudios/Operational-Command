# TriggerAPI::get_unit_strength Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 511–517)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_unit_strength(id_or_callsign: String) -> float
```

- **id_or_callsign**: Unit ID or callsign.
- **Return Value**: Current strength value (0.0 if destroyed/not found).

## Description

Get the current strength of a unit.
Strength is calculated as base strength × state_strength.
  
  

**Usage in trigger expressions:**

```
# Check if unit is below 50% strength
if get_unit_strength("ALPHA") < 50:
radio("ALPHA is heavily damaged!")

# Trigger when unit strength is critical
get_unit_strength("ALPHA") > 0 and get_unit_strength("ALPHA") < 20

# Compare strengths
var alpha_str = get_unit_strength("ALPHA")
var bravo_str = get_unit_strength("BRAVO")
if alpha_str > bravo_str * 2:
radio("ALPHA is significantly stronger than BRAVO")

# Tutorial: explain unit strength
if get_unit_strength("ALPHA") < 30 and not has_global("strength_warning_shown"):
set_global("strength_warning_shown", true)
tutorial_dialog("Your unit strength is low! Consider withdrawing.")
```

## Source

```gdscript
func get_unit_strength(id_or_callsign: String) -> float:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return 0.0
	return unit_data.get("strength", 0.0)
```
