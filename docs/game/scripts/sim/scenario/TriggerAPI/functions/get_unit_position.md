# TriggerAPI::get_unit_position Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 421–427)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_unit_position(id_or_callsign: String) -> Variant
```

- **id_or_callsign**: Unit ID or callsign.
- **Return Value**: Vector2 position in terrain meters, or null if unit not found.

## Description

Get the current position of a unit in terrain meters (Vector2).
  
  

**Usage in trigger expressions:**

```
# Get unit position
var pos = get_unit_position("ALPHA")
radio("ALPHA is at position " + str(pos))

# Check if unit reached a location
var target = vec2(1000, 500)
var pos = get_unit_position("ALPHA")
if pos and pos.distance_to(target) < 50:
radio("ALPHA reached the objective!")

# Point dialog at unit's current position
var pos = get_unit_position("BRAVO")
if pos:
show_dialog("Enemy spotted here!", false, pos)
```

## Source

```gdscript
func get_unit_position(id_or_callsign: String) -> Variant:
	var unit_data := unit(id_or_callsign)
	if unit_data.is_empty():
		return null
	return unit_data.get("position_m", null)
```
