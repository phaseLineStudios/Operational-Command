# TriggerAPI::vec2 Function Reference

*Defined at:* `scripts/sim/scenario/TriggerAPI.gd` (lines 618–621)</br>
*Belongs to:* [TriggerAPI](../../TriggerAPI.md)

**Signature**

```gdscript
func vec2(x: float, y: float) -> Vector2
```

- **x**: X coordinate
- **y**: Y coordinate
- **Return Value**: Vector2 with given coordinates

## Description

Create a Vector2 from x and y coordinates.
Use this helper to construct Vector2 in trigger expressions.
  
  

**Usage in trigger expressions:**

```
# Show dialog with line to position
show_dialog("Check here!", false, vec2(500, 750))

# Store position in global variable
set_global("checkpoint", vec2(1000, 500))
```

## Source

```gdscript
func vec2(x: float, y: float) -> Vector2:
	return Vector2(x, y)
```
