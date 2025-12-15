# TriggerAPI::has_drawn Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 323–328)</br>
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

## Source

```gdscript
func has_drawn() -> bool:
	if drawing_controller and drawing_controller.has_method("has_drawing"):
		return drawing_controller.has_drawing()
	return false
```
