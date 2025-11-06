# TriggerAPI::has_drawn Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 302–307)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func has_drawn() -> bool
```

- **Return Value**: True if player has made any drawings.

## Description

Check if the player has drawn anything on the map.
Returns true if any pen strokes have been made with the drawing tools.
  
  

**Usage in trigger condition:**

```
# Trigger activates when player has drawn on the map
has_drawn()

# Combined with other conditions
has_drawn() and time_s() > 60
```

## Source

```gdscript
func has_drawn() -> bool:
	if drawing_controller and drawing_controller.has_method("has_drawing"):
		return drawing_controller.has_drawing()
	return false
```
