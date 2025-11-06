# TriggerAPI::get_unit_grid Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 448–458)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func get_unit_grid(id_or_callsign: String, digits: int = 6) -> String
```

- **id_or_callsign**: Unit ID or callsign.
- **digits**: Total number of digits in grid (default 6).
- **Return Value**: Grid position string (e.g., "630852"), or empty string if unit not found.

## Description

Get the current grid position of a unit (e.g., "630852").
  
  

**Usage in trigger expressions:**

```
# Get unit grid position
var grid = get_unit_grid("ALPHA")
radio("ALPHA is at grid " + grid)

# Tutorial: explain grid coordinates
var grid = get_unit_grid("ALPHA")
tutorial_dialog("You are at grid " + grid + ". Use this for radio reports.")

# Check if unit is in specific grid area
var grid = get_unit_grid("BRAVO")
if grid.begins_with("63"):
radio("BRAVO is in the northern sector")
```

## Source

```gdscript
func get_unit_grid(id_or_callsign: String, digits: int = 6) -> String:
	var pos: Variant = get_unit_position(id_or_callsign)
	if pos == null or not (pos is Vector2):
		return ""

	if map_controller == null or map_controller.renderer == null:
		return ""

	return map_controller.renderer.pos_to_grid(pos, digits)
```
